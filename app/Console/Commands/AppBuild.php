<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Artisan;
use Symfony\Component\Process\Process;
use Symfony\Component\Process\Exception\ProcessFailedException;

class AppBuild extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:build 
     {--perms : set permissions}
     {--host : set env and .htaccess}
     {--clean : clean build}
     {--build : build }
     ' ;

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Application Build Utility';

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
    private function runHost()
    {
        print "starting host env update\n";

        // this includes perms setting
        $process = new Process('/bin/sh ./build.sh host');

        $process->start();
        print $process->getIncrementalOutput();
        //$process->run();
        while ($process->isRunning()) {
            sleep(1);
            print $process->getIncrementalOutput();
        }

        // executes after the command finishes
        if (!$process->isSuccessful()) {
            throw new ProcessFailedException($process);
        }
        Artisan::call('key:generate');

        // $process->getIncrementalOutput();

        //echo $process->getOutput();
        print "done with build\n";
    }
    
    private function runBuild()
    {
    //
        // as a first approximation, 


        //$old_path = getcwd();
        //chdir('/my/path/');
        // set_time_limit(60*20);
        print "starting build\n";

        // this includes perms setting
        $process = new Process('/bin/sh ./build.sh');

        $process->start();
        print $process->getIncrementalOutput();
        //$process->run();
        while ($process->isRunning()) {
            sleep(1);
            print $process->getIncrementalOutput();

        }

        // executes after the command finishes
        if (!$process->isSuccessful()) {
            throw new ProcessFailedException($process);
        }

        // $process->getIncrementalOutput();

        //echo $process->getOutput();
        print "done with build\n";
    }
    
    private function setPerms() 
    {
        print "setting permissions \n";
        $process = new Process('/bin/sh ./build.sh perms');  

        $process->start();
        print $process->getIncrementalOutput();
        //$process->run();
        while ($process->isRunning()) {
            sleep(1);
            print $process->getIncrementalOutput();
        }

        // executes after the command finishes
        if (!$process->isSuccessful()) {
            throw new ProcessFailedException($process);
        }

        // $process->getIncrementalOutput();

        //echo $process->getOutput();
        print "done with perms\n";
    }
    
    private function cleanBuild() 
    {
        print "cleaning build artifacts\n";
        $process = new Process('/bin/sh ./build.sh clean');  

        $process->start();
        print $process->getIncrementalOutput();
        //$process->run();
        while ($process->isRunning()) {
            sleep(1);
            print $process->getIncrementalOutput();
        }

        // executes after the command finishes
        if (!$process->isSuccessful()) {
            throw new ProcessFailedException($process);
        }

        // $process->getIncrementalOutput();

        //echo $process->getOutput();
        print "done with clean\n";
    }
    
    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle()
    {
        // just run a shell script    
         $options = $this->checkForInput($this->option());
	
    	if ($options['clean'] == 1 ) {
            $this->cleanBuild();
    	} 
    	if ($options['host'] == 1 ) {
    	    $this->runHost();
    	}
    	if ($options['build'] == 1 ) {
    	    $this->runBuild();
    	}
    	if ($options['perms'] ==1 ) {
               $this->setPerms();
    	}
        //chdir($old_path);
    }
}
