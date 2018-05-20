<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;

use Symfony\Component\Process\Process;
use Symfony\Component\Process\Exception\ProcessFailedException;

class AppDeploy extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:deploy' ;

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Application Deployment Utility';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }
    /**
     *
     */
    public function checkForInput($options){
        $configs= array(
            'options' => array(
            ),
            'flags' => FILTER_FLAG_ALLOW_OCTAL,
        );

      return $options;
    }
    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {
        //
        // as a first approximation, 
        // just run a shell script    
         $options = $this->checkForInput($this->option());

        //$old_path = getcwd();
        //chdir('/my/path/');
        // set_time_limit(60*20);
        print "starting deploy, please wait\n";

        // this includes perms setting
        $process = new Process('/bin/sh ./deploy.sh');

        $process->start();
        print $process->getIncrementalOutput();
        //$process->run();
        while ($process->isRunning()) {
            sleep(5);
            print $process->getIncrementalOutput();

        }

        // executes after the command finishes
        if (!$process->isSuccessful()) {
            throw new ProcessFailedException($process);
        }

        // $process->getIncrementalOutput();

        //echo $process->getOutput();
        print "done with deploy\n";
        //chdir($old_path);
    }
}
