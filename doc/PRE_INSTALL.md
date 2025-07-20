This installation script will set the admin user (which will be selected by you) and password, which will be randomly generated (unless specified otherwise).

#### System Requirements
- Python 3.13 or higher (taken care of automatically)

#### Warning
- This does not support SSO or LDAP and is intended for local use only. External exposure is not advised.


#### Recommendations
- Make sure to do proper backups of the whole instance as well as the apps and data within Yunohost. Installs can always break something, so be prepared.
- Even though it does not support SSO/LDAP, you are still able to set the same admin user and password during install, if you wish. It is best practice to use different credentials whenever possible, however.