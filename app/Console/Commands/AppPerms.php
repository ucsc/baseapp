<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;

use Symfony\Component\Process\Process;
use Symfony\Component\Process\Exception\ProcessFailedException;

class AppPerms extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:perms';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Application Permissions Utility';

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

        print "starting perms, please wait\n";
        $process = new Process('/bin/sh ./build.sh perms');  

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

        //echo $process->getOutput();
        print "done with sync\n";
        //chdir($old_path);
    }
}
