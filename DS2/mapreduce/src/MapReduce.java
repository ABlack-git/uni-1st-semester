import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class MapReduce {

    public enum Header {
        AGE, GENDER, DATE, OFFENSE, DISTRICT;
    }

    public static class WritablePair implements Writable {
        private int counter;
        private int age;

        public WritablePair() {
        }

        public WritablePair(int counter, int age) {
            this.counter = counter;
            this.age = age;
        }

        public int getCounter() {
            return counter;
        }

        public int getAge() {
            return age;
        }

        @Override
        public void write(DataOutput dataOutput) throws IOException {
            dataOutput.writeInt(counter);
            dataOutput.writeInt(age);
        }

        @Override
        public void readFields(DataInput dataInput) throws IOException {
            counter = dataInput.readInt();
            age = dataInput.readInt();
        }
    }

    public static class PdbMapper extends Mapper<Object, Text, Text, WritablePair> {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String north = "North";
        String east = "East";
        Date thresholdDate;

        @Override
        protected void setup(Context context) throws IOException, InterruptedException {
            try {
                thresholdDate = dateFormat.parse("2019-03-01");
            } catch (ParseException e) {
                throw new IOException(e);
            }
        }

        @Override
        protected void map(Object key, Text value, Context context) throws IOException, InterruptedException {
            String[] row = value.toString().split(",");
            Date arrestDate = null;
            int age = -1;
            try {
                arrestDate = dateFormat.parse(row[Header.DATE.ordinal()]);
                age = Integer.parseInt(row[Header.AGE.ordinal()]);
            } catch (ParseException | NumberFormatException e) {
                throw new IOException(e);
            }
            String district = row[Header.DISTRICT.ordinal()];
            String offence = row[Header.OFFENSE.ordinal()];
            if (row[Header.GENDER.ordinal()].equals("M")
                    && arrestDate.after(thresholdDate)
                    && (district.equals(north) || district.equals(east))) {
                context.write(new Text(offence), new WritablePair(1, age));
            }
        }
    }

    public static class PdbReducer extends Reducer<Text, WritablePair, Text, Text> {
        @Override
        protected void reduce(Text key, Iterable<WritablePair> values, Context context) throws IOException, InterruptedException {
            int sumCounter = 0;
            int sumAge = 0;
            for (WritablePair p : values) {
                sumAge += p.getAge();
                sumCounter += p.getCounter();
            }
            double avgAge = (double) sumAge / sumCounter;
            String out = String.format("numOffences: %d, averageAge: %.2f", sumCounter, avgAge);
            context.write(key, new Text(out));
        }
    }

    public static void main(String[] args) throws Exception {

        Configuration conf = new Configuration();

        Job job = Job.getInstance(conf, "WordCount");

        job.setJarByClass(MapReduce.class);
        job.setMapperClass(MapReduce.PdbMapper.class);
//        job.setCombinerClass(MapReduce.PdbReducer.class);
        job.setReducerClass(MapReduce.PdbReducer.class);
        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(WritablePair.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);

        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        System.exit(job.waitForCompletion(true) ? 0 : 1);

    }
}
