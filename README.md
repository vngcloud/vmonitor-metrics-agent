# linux
1. install

```sh
VERSION=1.16.0-1.0 API_KEY=<YOUR API_KEY> bash -c "$(curl -L https://raw.githubusercontent.com/vmonitor/monitoring/main/install.sh)"
```
2. config

```sh
/etc/telegraf/telegraf.conf
/etc/default/telegraf
```

3. start telegraf
- Linux (sysvinit and upstart installations)
```sh
sudo service telegraf start
```

- Linux (systemd installations)
```sh
systemctl start telegraf
```

# windows

```
   [[outputs.vcmc]]
      url = "https://<VMONITOR_SITE>"
      insecure_skip_verify = false
      data_format = "vcmc"
      api_key = "<API_KEY>"
```

> download https://github.com/vmonitor/monitoring/releases

## Running Telegraf as a Windows Service

Telegraf natively supports running as a Windows Service. Outlined below is are
the general steps to set it up.

1. Obtain the telegraf windows distribution
2. Create the directory `C:\Program Files\Telegraf` (if you install in a different
   location simply specify the `--config` parameter with the desired location)
3. Place the telegraf.exe and the telegraf.conf config file into `C:\Program Files\Telegraf`
4. To install the service into the Windows Service Manager, run the following in PowerShell as an administrator (If necessary, you can wrap any spaces in the file paths in double quotes ""):

   ```
   > C:\"Program Files"\Telegraf\telegraf.exe --service install
   ```

5. Edit the configuration file to meet your needs
6. To check that it works, run:

   ```
   > C:\"Program Files"\Telegraf\telegraf.exe --config C:\"Program Files"\Telegraf\telegraf.conf --test
   ```

7. To start collecting data, run:

   ```
   > net start telegraf
   ```

## Config Directory

You can also specify a `--config-directory` for the service to use:
1. Create a directory for config snippets: `C:\Program Files\Telegraf\telegraf.d`
2. Include the `--config-directory` option when registering the service:
   ```
   > C:\"Program Files"\Telegraf\telegraf.exe --service install --config C:\"Program Files"\Telegraf\telegraf.conf --config-directory C:\"Program Files"\Telegraf\telegraf.d
   ```

## Other supported operations

Telegraf can manage its own service through the --service flag:

| Command                            | Effect                        |
|------------------------------------|-------------------------------|
| `telegraf.exe --service install`   | Install telegraf as a service |
| `telegraf.exe --service uninstall` | Remove the telegraf service   |
| `telegraf.exe --service start`     | Start the telegraf service    |
| `telegraf.exe --service stop`      | Stop the telegraf service     |

## Install multiple services

Running multiple instances of Telegraf is seldom needed, as you can run
multiple instances of each plugin and route metric flow using the metric
filtering options.  However, if you do need to run multiple telegraf instances
on a single system, you can install the service with the `--service-name` and
`--service-display-name` flags to give the services unique names:

```
> C:\"Program Files"\Telegraf\telegraf.exe --service install --service-name telegraf-1 --service-display-name "Telegraf 1"
> C:\"Program Files"\Telegraf\telegraf.exe --service install --service-name telegraf-2 --service-display-name "Telegraf 2"
```

## Troubleshooting

When Telegraf runs as a Windows service, Telegraf logs messages to Windows events log before configuration file with logging settings is loaded.
Check event log for an error reported by `telegraf` service in case of Telegraf service reports failure on its start: Event Viewer->Windows Logs->Application

**Troubleshooting  common error #1067**

When installing as service in Windows, always double check to specify full path of the config file, otherwise windows service will fail to start

 --config "C:\Program Files\Telegraf\telegraf.conf"
