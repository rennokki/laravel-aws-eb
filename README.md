# Laravel EB
Laravel EB is a sample configuration to help you deploy a Laravel app on an AWS Elasitc Beanstalk PHP environment.

# Packaged
The sample configuration comes with:
* Automatically copying of .env from Elastic Beanstalk's S3 bucket (so you won't have to add the environment variables directly in the console)
* Artisan Scheduler cron configuration that triggers every minute
* supervisord for Queues/Horizon (coming packaged with Horizon)

# Installation
Download the configuration files and drop the `.ebextensions` folder directly in your project root.

# AWS EB Mainframes
AWS EB has some tricky parts which I'm going to explain:
* The main folders are `/var/app/ondeck` (before the deploy) and `/var/app/current` which is the current configuration.
* Each deploy makes you lose everything you have in the `current` folder. Do not rely on local storage, use S3 instead with CloudFront to avoid data loss.
* The configuration files and defined commands are run in alphabetical order. I prefer to use numbers for this since it's easier to visualize & understand which runs after which.

# Configuration files
## 00_copy_environment_variables.config
After creating your project and an environment for it, an S3 bucket is created with a name similar to this one: `elasticbeanstalk-[region]-xxxxxxxxxxx`. This is EB's S3 bucket for that region and it can be used to drop in the `.env` file from where you can copy it on each deploy. Make sure you change the `buckets`and `source` variables with the right ones within the file.

In case you have multiple projects on the same EB region, make sure you have an unique name for each one. Additionally, make sure you edit the `01_deploy.config` and change the `00_01_move_environment_file` copied file name within the `container_commands`.

## 00_create_cron_file.config
This is the place where the cronfile for `php artisan schedule:run` is configured and copied.

## 00_create_hooks_scripts.config
Some commands need to be run after the deployment takes place. For example, restarting supervisor processes. Aditionally, all `cache` commands (`config:cache`, `route:cache` and `view:cache`) are re-run here (they are run also in `01_deploy.config`) due to a permission bug that is unknown.

## 00_install_supervisord.config
Supervisord is used to hold up queues, but mostly for daemonized processes, in general. It comes pre-packaged with a config for Laravel Horizon. You can just delete the `/tmp/laravel.conf` file creation within `files` and add your own configuration, but make sure to change the `mv` command within the `container_commands`:

```config
files:
  ...
  "/tmp/laravel.conf":
    mode: "000755"
    owner: root
    group: root
    content: |
      [program:horizon]
      process_name=%(program_name)s_%(process_num)02d
      command=php /var/app/current/artisan queue:work
      autostart=true
      autorestart=true
      user=root
      numprocs=1
      redirect_stderr=true
      stdout_logfile=/dev/null

      [program:echo-server]
      process_name=%(program_name)s_%(process_num)02d
      command=laravel-echo-server start
      autostart=true
      autorestart=true
      user=root
      numprocs=1
      redirect_stderr=true
      stdout_logfile=/dev/null

...

container_commands:
  01_01_copy_supervisor_configuration_files:
    command: |
      sudo mv /tmp/supervisord.conf /etc/supervisord.conf
      sudo mv /tmp/laravel.conf /etc/supervisor/conf.d/laravel.conf # this line here
...
```

Keep in mind that you can add as many `[program:xxxxx]` as you'd like. They will all be read in Supervisor.

## 01_deploy.config
This file is the deployment itself. The only thing you have to do is to configure the `container_commands` section with your desired commands to be ran on each deployment. The trick parts here are:
* Commands run on `/var/app/ondeck` since the deployment is not ready. The post-deploy (after the new code is live) hooks are in `00_create_hooks_scripts.config` and can be configured out there.
* The `leader_only` property allows the command to be run only once, on one server, during the deployment. The leader instance is picked by AWS and this property should be used to run commands only once (since all commands that don't have a `leader_only` property will be ran on every instance; this is a case for migrations since it's okay to run only once the migrations and avoid errors).

It's highly recommended that the `xx_xx_fix_permisions`, `xx_xx_storage_link`, `xx_xx_caches` and `xx_xx_rerun_caches` to stay in place since they solve permission errors that may occur at any time.

PHP allows you to choose the memory limit for your app. You can do so by changing the `memory_limit` option to something right for your app, according to the instance type you're using. It comes pre-packaged with `512M`, but it can be anything.

# Laravel Passport
Since Laravel Passport uses local storage to keep the public and private key, there is no way of using this method. Instead, you might use what this PR added: https://github.com/laravel/passport/pull/683

In your `.env` file, add the following variables **and make sure that there is a `\\n` for each newline**:
```
PASSPORT_PRIVATE_KEY="-----BEGIN RSA PRIVATE KEY-----\\nMIIJJwIBAAKCAgEAw3KPag...\\n-----END RSA PRIVATE KEY-----"
PASSPORT_PUBLIC_KEY="-----BEGIN PUBLIC KEY-----\\nMIICIjANBgkqhkiG9w0BAQEFAAOC...\\n-----END PUBLIC KEY-----\\n"
```

# Run Spot Instances
Spot instances can be configured from the console. Check out AWS announcement: https://aws.amazon.com/about-aws/whats-new/2019/11/aws-elastic-beanstalk-adds-support-for-amazon-ec2-spot-instances/

# Deploying with AWS EB CLI
To deploy to the EB environment, you have two choices:
* Archive the ZIP by your own and upload it.
* Pull from git, and use AWS EB CLI in the current folder (with no additional ZIP-ing)

AWS EB CLI make use of `.gitignore` and `.ebignore`. The only pre-configuration you need is to add the following environment variables
to your CI/CD machine:
* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_EB_REGION`

If you use a dockerized CI/CD pipeline (like Gitlab CI), you can make use of the `coxauto/aws-ebcli:latest` image. The following commands let you deploy an app on a certain environment within Gitlab CI on tag creation, for example:
```bash
$ git checkout $CI_COMMIT_TAG
$ eb init --region=$AWS_EB_REGION --platform=php [project-name]
$ eb use [environment-name]
$ eb deploy [environment-name] --label=$CI_COMMIT_TAG
```
