dockerenv_mysql
===============

dockerenv mysql

### Tags
Available tags listed here: https://hub.docker.com/r/avatarnewyork/dockerenv-mysql/tags/

### Slave Option (currently only available in tag: percona56)
You can setup a slave server given the following conditions:

* You must be starting with a blank database (both master and slave).  If you have existing data, mysqldump and then import it after the new master/slave setup.
* you must be using percona56
* the master db name is db in the yml file and the slave can be anything else.
* you must setup and mount volumes for both master AND slave (outside normal dockerenv)
* you must link the slave to the master (see links in example below)
* you must set the following environment varibles (SERVER_ID can be anything but master / slave must be different):
  * Master DB
    * SERVER_ID: 1
  * Slave DB
    * SERVER_ID: 2
    * SLAVE: 1

#### Example yaml
Really only need to pay attention to environment variables.

```yaml
db:
  build: .
  ports:
    - "3366:3306"
  environment:
    SERVER_ID: 1
dbslave:
  build: .
  ports:
    - "3666:3306"
  links:
    - db
  environment:
    SERVER_ID: 2
    SLAVE: 1
```
