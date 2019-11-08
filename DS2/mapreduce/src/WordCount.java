
import java.io.IOException;
import java.util.StringTokenizer;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class WordCount {
    
    public static class MyMapper
         extends Mapper<Object, Text, Text, IntWritable>
    {
        
        @Override
        public void map(
            Object key,
            Text value,
            Context context
        ) throws IOException, InterruptedException {
            
            StringTokenizer i = new StringTokenizer(value.toString());
            while (i.hasMoreTokens()) {
                String word = i.nextToken();
                context.write(
                    new Text(word),
                    new IntWritable(1)
                );
            }
            
        }
        
    }
    
    public static class MyReducer
        extends Reducer<Text, IntWritable, Text, IntWritable>
    {
        
        @Override
        public void reduce(
            Text key,
            Iterable<IntWritable> values,
            Context context
        ) throws IOException, InterruptedException {
            
            int sum = 0;
            for (IntWritable v : values) {
                sum += v.get();
            }
            context.write(
                key,
                new IntWritable(sum)
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
