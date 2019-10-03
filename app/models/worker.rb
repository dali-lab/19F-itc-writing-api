require 'pty'
class Worker

  def self.start
    
    worker_file_path = "#{Dir.tmpdir}/worker_pid"
    File.delete(worker_file_path) if File.exist?(worker_file_path)
    
    exception = nil
    begin
      PTY.spawn( "RAILS_ENV=#{Rails.env} QUEUES=mailers rake jobs:work" ) do |stdout, stdin, pid|
        begin
          File.open(worker_file_path, 'w') {|f| f.write(pid) }
          puts "spawned rake job pid: #{pid}\n"
          stdout.each { |line| print line }
        rescue Errno::EIO
          puts "=======> CATCHING KILLING THE RAKE TASK HERE <=========="
          exception = Errno::EIO
        end
      end
    rescue PTY::ChildExited
      puts "The child process exited!"
      exception = PTY::ChildExited
    rescue => e
      puts "delayed_job worker failed: #{e}"
      exception = e
    end
    puts "returning from worker.start"
    exception = RuntimeError.new("delayed job worker rake task was restarted") if exception.nil?
    ExceptionNotifier.notify_exception(exception)
    sleep 5 # allow time for puma to settle and quit if that's what killed our worker
    Thread.new { Worker.start }
  end

end
