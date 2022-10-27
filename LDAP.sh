#!/bin/bash
#Config LDAP

echo Starting Script . . .

sudo touch /etc/ldap/users.ldif
sudo touch /etc/ldap/userTest.ldif

#Config files content

LDAPUsers_FILE="/etc/ldap/users.ldif"
cat <<EOM >$LDAPUsers_FILE

dn: ou=People,dc=lin1,dc=local
objectClass: organizationalUnit
ou: People

EOM

LDAPUser_FILE="/etc/ldap/user.ldif"
cat <<EOM >$LDAPUser_FILE

dn: cn=david,ou=People,dc=lin1,dc=local
objectClass: top
objectClass: account
objectClass: posixAccount
objectClass: shadowAccount
cn: david
uid: david
uidNumber: 10001
gidNumber: 10001
homeDirectory: /home/david
userPassword: david1
loginShell: /bin/bash

EOM

#Apply LDAP Config

sudo ldapadd -D "cn=admin,dc=lin1,dc=local" -W -H ldapi:/// -f /etc/ldap/users.ldif
sudo ldapadd -D "cn=admin,dc=lin1,dc=local" -W -H ldapi:/// -f /etc/ldap/user.ldif

echo End

