FROM centos:centos6
#MAINTAINER Patrick Tully <patrick+docker@avatarnewyork.com>

# using epel
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm -Uvh http://repo.mysql.com/mysql-community-release-el6-5.noarch.rpm
Run yum -y update

# set time to EST5EDT
RUN ln -sf /usr/share/zoneinfo/EST5EDT /etc/localtime

# install packages
RUN yum -y --enablerepo=mysql56-community install mysql-server mysql
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
