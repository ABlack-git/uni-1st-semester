import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.FileSplit;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.StringTokenizer;

public class WordFileCount {

    public static class MyMapper
            extends Mapper<Object, Text, Text, Text> {

        @Override
        public void map(
                Object key,
                Text value,
                Context context
        ) throws IOException, InterruptedException {

            StringTokenizer i = new StringTokenizer(value.toString());
            String fileName = ((FileSplit) context.getInputSplit()).getPath().getName();
            while (i.hasMoreTokens()) {
                String word = i.nextToken();
                context.write(
                        new Text(word),
                        new Text(fileName)
                );
            }

        }

    }

    public static class MyReducer
            extends Reducer<Text, Text, Text, Text> {

        @Override
        public void reduce(
                Text key,
                Iterable<Text> values,
                Context context
        ) throws IOException, InterruptedException {

            Map<String, Integer> map = new HashMap<>();
            for (Text v : values) {
                String filName = v.toString();
                map.putIfAbsent(filName, 0);
                Integer count = map.get(filName);
                map.put(filName, count);
            }

            context.write(
                    key,
                    new Text("")
            );

        }

    }

    public static void main(String[] args) throws Exception {

        Configuration conf = new Configuration();

        Job job = Job.getInstance(conf, "WordCount");

        job.setJarByClass(WordCount.class);
        job.setMapperClass(MyMapper.class);
        job.setCombinerClass(MyReducer.class);
        job.setReducerClass(MyReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);

        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        System.exit(job.waitForCompletion(true) ? 0 : 1);

    }

}
