#!/bin/bash

# server backup postfix & co

# init
Log=0
Debug=0

shellName=$0

ListeConfFile="\
 /etc/postfixadmin/dbconfig.inc.php\
 /etc/postfixadmin/config.inc.php\
 /etc/apache2/conf-available/postfixadmin.conf\
 /etc/postfix/mysql_virtual_alias_domainaliases_maps.cf\
 /etc/postfix/mysql_virtual_alias_maps.cf\
 /etc/postfix/mysql_virtual_domains_maps.cf\
 /etc/postfix/mysql_virtual_mailbox_domainaliases_maps.cf\
 /etc/postfix/mysql_virtual_mailbox_maps.cf\
 /etc/postfix/main.cf\
 /etc/postfix/master.cf\
 /etc/postfix/header_checks\
 /etc/postfix/esmtp_access\
 /etc/dovecot/dovecot-sql.conf.ext\
 /etc/dovecot/conf.d/10-auth.conf\
 /etc/dovecot/conf.d/10-mail.conf\
 /etc/dovecot/conf.d/10-ssl.conf\
 /etc/dovecot/conf.d/10-master.conf\
 /etc/dovecot/conf.d/15-lda.conf\
 /etc/dovecot/conf.d/90-sieve.conf\
 /etc/dovecot/conf.d/15-mailboxes.conf\
 /etc/dovecot/dovecot.conf\
 /home/mail/sieve.default\
 /etc/amavis/conf.d/05-node_id\
 /etc/amavis/conf.d/15-content_filter_mode\
 /etc/amavis/conf.d/20-debian_defaults\
 /etc/default/spamassassin\
 /etc/ssl/openssl.cnf\
 /etc/ssl/private/mail.crt\
 /etc/ssl/private/mail.key\
 /etc/roundcube/config.inc.php\
 /etc/roundcube/apache.conf\
 /etc/fail2ban/jail.local\
 /etc/roundcube/plugins/password/config.inc.php\
 /var/lib/roundcube/plugins/password/config.inc.php.dist\
 /etc/init.d/firewall.sh\
"

function servicesMail
{
	option=$1

	[[ $Log > 0 ]] && printf "[$shellName Log($Log) (function $0)  option = $option\n" >&2

	if [[ $Debug > 0 ]]
	then
		printf "[$shellName Debug($Debug)] sudo service postfix $option >&2\n"
#		printf "[$shellName Debug($Debug)] sudo service sendmail $option >&2\n"
		printf "[$shellName Debug($Debug)] sudo service spamassassin $option >&2\n"
		printf "[$shellName Debug($Debug)] sudo service clamav-daemon $option >&2\n"
		printf "[$shellName Debug($Debug)] sudo service amavis $option >&2\n"
		printf "[$shellName Debug($Debug)] sudo service dovecot $option >&2\n"
	else
		sudo service postfix $option >&2
#		sudo service sendmail $option >&2
		sudo service spamassassin $option >&2
		sudo service clamav-daemon $option >&2
		sudo service amavis $option >&2
		sudo service dovecot $option >&2
	fi
	if [[ $option = "start" ]]
	then
		if [[ $Debug > 0 ]]
		then
			printf "[$shellName Debug($Debug)] sudo a2enconf roundcube >&2\n"
			printf "[$shellName Debug($Debug)] sudo a2enconf postfixadmin >&2\n"
		else
			sudo a2enconf roundcube >&2
			sudo a2enconf postfixadmin >&2
		fi
	else
		if [[ $Debug > 0 ]]
		then
			printf "[$shellName Debug($Debug)] sudo a2disconf roundcube >&2\n"
			printf "[$shellName Debug($Debug)] sudo a2disconf postfixadmin >&2\n"
		else
			sudo a2disconf roundcube >&2
			sudo a2disconf postfixadmin >&2
		fi
	fi
	if [[ $Debug > 0 ]]
	then
		printf "[$shellName Debug($Debug)] sudo systemctl reload apache2 >&2\n"
	else
		sudo systemctl reload apache2 >&2
	fi
}

[[ $Log > 0 ]] && printf "[$shellName Log($Log)] Demarrage\n" >&2

RSYNCSRC='/home/mail'
RSYNCDEST='/home/backup-mail'

if [[ ! -d $RSYNCDEST ]]
then
	echo $RSYNCDEST n\'existe pas ! >&2
	if [ $Debug > 0 ]
	then
		printf "[$shellName Debug($Debug)] sudo mkdir $RSYNCDEST\n" >&2
		sudo mkdir $RSYNCDEST
	fi
else
	[[ $Log > 0 ]] && printf "[$shellName Log($Log)] $RSYNCDEST existe\n" >&2
fi

#BackupDate=`date +"%Y%m%d"`
BackupDate=`date +"%Y%m"`
RSYNCDEST=$RSYNCDEST/mail-dirbkp_$BackupDate

[[ $Log > 0 ]] && printf "[$shellName Log($Log)] RSYNCDEST=$RSYNCDEST\n" >&2

# arrêt des services
servicesMail stop

# copy the full mail path
if [[ $Debug > 0 ]]
then
	printf "[$shellName Debug($Debug)] sudo sh -c \"rsync -Aavx $ListeConfFile $RSYNCSRC/ $RSYNCDEST/ >> $RSYNCDEST.lst\"\n" >&2
else
	sudo sh -c "rsync -Aavx $ListeConfFile $RSYNCSRC/ $RSYNCDEST/ >> $RSYNCDEST.lst"
fi

# dump bdd

if [[ $Debug > 0 ]]
then
	printf "[$shellName Debug($Debug)] sudo sh -c \"mysqldump --single-transaction -u root postfixadmin > $RSYNCDEST.postfixadmin.bak\"\n" >&2
	printf "[$shellName Debug($Debug)] sudo sh -c \"mysqldump --single-transaction -u root roundcube > $RSYNCDEST.roundcube.bak\"\n" >&2
else
	sudo sh -c "mysqldump --single-transaction -u root postfixadmin > $RSYNCDEST.postfixadmin.bak"
	sudo sh -c "mysqldump --single-transaction -u root roundcube > $RSYNCDEST.roundcube.bak"
fi

# redemarrage des services
servicesMail start

# restore
# rsync -Aax nextcloud-dirbkp/ nextcloud/
# mysql -h [server] -u [username] -p[password] -e "DROP DATABASE nextcloud"
# mysql -h [server] -u [username] -p[password] -e "CREATE DATABASE nextcloud"
# ou mysql -h [server] -u [username] -p[password] -e "CREATE DATABASE nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci"
# mysql -h [server] -u [username] -p[password] [db_name] < nextcloud-sqlbkp.bak
