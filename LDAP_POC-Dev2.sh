#Clean LDAP Script

#!/bin/bash

sudo touch /etc/ldap/content/newuser.ldif
sudo touch /etc/ldap/content/addtogroup.ldif

##########################################################
LDAP_FILE="/etc/ldap/content/users.ldif"
cat <<EOM >$LDAP_FILE

dn: uid=dev2,ou=users,dc=lin1,dc=local
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
objectClass: person
uid: dev2
userPassword: Password
cn: Dev 2
givenName: Dev
sn: 2
loginShell: /bin/bash
uidNumber: 10021
gidNumber: 20020
displayName: Dev 2
homeDirectory: /home/dev2
mail: dev2@lin1.local
description: Dev 2 account

EOM
##########################################################
LDAP_FILE="/etc/ldap/content/addtogroup.ldif"
cat <<EOM >$LDAP_FILE

dn: cn=Devloppeurs,dc=lin1,dc=local
changetype: modify
add: memberuid
memberuid: dev2
EOM
##########

sudo ldapadd -D "cn=admin,dc=lin1,dc=local" -W -H ldapi:/// -f /etc/ldap/content/newuser.ldif
sudo ldapmodify -D "cn=admin,dc=lin1,dc=local" -W -H ldapi:/// -f /etc/ldap/content/addtogroup.ldif

sudo ldapsearch -x -D "cn=admin,dc=lin1,dc=local" -b "dc=lin1,dc=local" -w 'Pa$$w0rd'
