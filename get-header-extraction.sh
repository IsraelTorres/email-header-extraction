#!/bin/bash
# Israel Torres
# 20170327
# extracts information from flat email headers
# then runs dig and whois on the information found

header_file="$1"
######################################################################
if [[ -z "$header_file" ]]
    then
        echo -en "usage:\tget-header-extraction.sh header_text_file.txt\n"
        exit 1
    else
        if [[ -f "$header_file" ]]
            then
                : #no-op
            else
                echo -en "usage:\tget-header-extraction.sh header_text_file.txt - file not found\n"
                exit 1
            fi
fi
######################################################################
function extract_ip_addresses () {

header_file="$1"
cat "$header_file" | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'

}

function extract_email_addresses () {

header_file="$1"
cat "$header_file" | grep -E -o "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b" 

}
######################################################################

IPADDRESSES=$(extract_ip_addresses "$header_file")
EMADDRESSES=$(extract_email_addresses "$header_file")

echo -en "### IP Addresses Extracted ###\n"
echo -en "$IPADDRESSES\n\n"

echo -en "### Email Addresses Extracted ###\n"
echo -en "$EMADDRESSES\n\n"
######################################################################
for x in $(echo "$IPADDRESSES")
	do
		echo "########### $x ###########"
		echo "------ dig $x ------"
		dig +short -x "$x"
		echo "------ whois $x ------"
		whois "$x" | grep "OrgName"
		echo "####################################################"
	done
######################################################################
# --- test case 01 begin ---
# expected input
# ./get-header-extraction.sh "file_containing_email_headers.txt"
#
# expected output
# ### IP Addresses Extracted ###
# x.x.x.x
# x.x.x.x
# ### Email Addresses Extracted ###
# x@exampleemail
# y@exampleemail
########### x.x.x.x ###########
#------ dig x.x.x.x ------
# example.site.address
#------ whois x.x.x.x ------
#OrgName:        Site Information Organization
####################################################
# --- test case 01 end ---
#
#EOF