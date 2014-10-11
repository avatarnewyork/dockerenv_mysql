FROM centos:centos5
#MAINTAINER Patrick Tully <patrick+docker@avatarnewyork.com>

# using epel
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm
Run yum -y update

# install packages
RUN yum -y install mysql-server mysql
ADD ./root/packages.sh /packages.sh
RUN chmod 755 /packages.sh
RUN /packages.sh

# MySQL
RUN echo "NETWORKING=yes" > /etc/sysconfig/network
# Remove pre-installed database
#RUN rm -rf /var/lib/mysql/*
ADD mysqld_charset.cnf /etc/mysql/conf.d/mysqld_charset.cnf
ADD mysql_startup.sh /mysql_startup.sh

RUN chmod 755 /*.sh

EXPOSE 3306

CMD "/mysql_startup.sh"
