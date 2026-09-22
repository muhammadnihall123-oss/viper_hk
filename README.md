VIPER FINDER
URL FINDER TOOL

Version: 1.0

DESCRIPTION

Viper Finder is a Bash-based URL extraction tool.

It uses curl to download a web page and extracts links from
HTML href attributes.

The tool can process URLs supplied individually or from a text
file, depending on which version of the script you are using.

Extracted links are saved into the "results" directory.

FEATURES

Bash-based

Uses curl for HTTP/HTTPS requests

Supports HTTP and HTTPS URLs

Automatically adds HTTPS when a URL has no scheme

Extracts href links from HTML

Removes duplicate links

Ignores:

fragments

javascript: links

mailto: links

tel: links

Follows redirects

Uses a 20-second request timeout

Saves results to timestamped files

Displays colored terminal output

Handles Ctrl+C interruption

Supports processing multiple URLs from a file

REQUIREMENTS

Operating system:

Linux

macOS

WSL

Other Unix-like systems with Bash

Required software:

Bash

curl

grep

sed

sort

wc

date

CHECK CURL

Run:

curl --version


If curl is not installed, install it using your operating
system's package manager.

INSTALLATION

Save the script as:

viper-finder.sh

Make the script executable:

chmod +x viper-finder.sh

Create a URL input file if using the file-based version.

Example:

urls.txt


Run the script:

./viper-finder.sh

URL INPUT FILE

The URL input file should contain one URL per line.

Example:

https://example.com
https://example.org
https://example.net


You can also provide URLs without a scheme:

example.com
example.org
example.net


The script automatically converts these to:

https://example.com
https://example.org
https://example.net

BLANK LINES

Blank lines are ignored.

Example:

https://example.com

https://example.org

COMMENTS

Lines beginning with "#" are ignored by the file-based version.

Example:

# Main websites
https://example.com

# Documentation
https://example.org/docs

RUNNING THE TOOL

Make the script executable:

chmod +x viper-finder.sh


Run:

./viper-finder.sh


The script will ask for the URL input file.

Example:

[?] ENTER URL FILE → urls.txt

OUTPUT

Results are stored inside:

results/


For example:

results/example_com_20260922_121100.txt


Each output file contains one extracted href per line.

Example:

/about
/contact
/products
https://example.org
/login

DUPLICATES

Duplicate links are automatically removed using:

sort -u


Therefore, the same href will only appear once in the
output file.

IGNORED LINKS

The extractor ignores links beginning with:

#
javascript:
mailto:
tel:


For example:

#section

javascript:void(0)

mailto:user@example.com

tel:+123456789


These links are excluded from the results.

REDIRECTS

curl is configured with:

--location


This allows the tool to follow HTTP redirects.

For example:

http://example.com


may redirect to:

https://example.com

TIMEOUT

Each request has a maximum timeout of 20 seconds.

This is configured with:

--max-time 20

USER AGENT

The script identifies itself to the server as:

ViperFinder/1.0


This is configured with:

--user-agent "ViperFinder/1.0"

RESULT DIRECTORY

The script automatically creates:

results/


if the directory does not already exist.

Example directory structure:

.
├── viper-finder.sh
├── urls.txt
└── results
    ├── example_com_20260922_120000.txt
    ├── example_org_20260922_120005.txt
    └── example_net_20260922_120010.txt

TROUBLESHOOTING

"curl is not installed"

Install curl and run the script again.

"File not found"

Make sure the URL input file exists.

Check with:

ls -l urls.txt


"Failed to fetch"

Possible causes include:

The website is unavailable.

The URL is incorrect.

DNS resolution failed.

The server rejected the request.

The connection timed out.

The server requires authentication.

Network connectivity is unavailable.

"No links found"

The downloaded page may contain:

No href attributes

Links generated dynamically with JavaScript

An unusual HTML structure

Content that requires authentication

IMPORTANT

This tool performs HTTP/HTTPS requests against the URLs you
provide.

Only scan websites and systems that you own or have permission
to test.

Respect:

Website terms of service

Robots and access policies

Rate limits

Applicable laws

Authorization requirements

LIMITATIONS

This tool is a simple HTML href extractor.

It does NOT:

Crawl an entire website recursively

Automatically discover every page on a domain

Execute JavaScript

Parse dynamically generated links

Authenticate to protected websites

Extract URLs from JavaScript source

Extract URLs from CSS

Discover links hidden behind forms

Guarantee that every extracted href is reachable

RELATIVE URLS

The current extractor saves href values exactly as they appear
in the HTML.

For example, if a page contains:

<a href="/about">About</a>


the output will contain:

/about


It will not automatically convert it to:

https://example.com/about


Likewise:

<a href="contact.html">Contact</a>


will remain:

contact.html

SECURITY NOTES

The script uses the target URL as an argument to curl rather than
executing it as shell code.

Do not modify the script to use:

eval "$TARGET"


or similar constructs.

Avoid inserting untrusted input directly into shell commands.

FILE NAMING

The file-based version creates a safe filename from the target
URL.

For example:

https://example.com/test


may produce a filename similar to:

example_com_test_20260922_121100.txt


The timestamp helps prevent previous results from being
overwritten.

EXAMPLE WORKFLOW

Create an input file:

nano urls.txt


Add:

https://example.com
https://example.org
https://example.net


Save the file.

Make the script executable:

chmod +x viper-finder.sh


Run:

./viper-finder.sh


Enter:

urls.txt


The script processes each URL and saves the extracted links
inside:

results/

EXAMPLE OUTPUT
🐍 VIPER FINDER — FINISHED 🐍

[✓] Found 24 URLs
    Saved to: results/example_com_20260922_121100.txt

[✓] Found 17 URLs
    Saved to: results/example_org_20260922_121105.txt

LICENSE

Use, modify, and distribute this script according to the license
you choose for your project.

If you publish the project publicly, consider adding an explicit
LICENSE file describing the permitted use.

AUTHOR

Viper Finder

END

🐍 VIPER FINDER — URL FINDER TOOL 🐍
