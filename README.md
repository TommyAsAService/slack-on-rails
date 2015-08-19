# slack-on-rails

A slack plug-in for various Slash Commands.
At the moment, supported Slash Command included:
* /youtube [keyword]
Future features are in development. Stay tune for more supported Slash Commands

# Usage

Just type `/youtube [keywords]` to your slack and a cloned bot of yourself will post random Youtube link based on the keywords.

# Installation
The overall installation process involves the following:

* Creating a Slash Command integration to trigger youtube
* Acquiring the Slack Web API token for your team to allow the response to mimic the user that triggered the command
* Acquring the Google Youtube API token for finding Youtube title based on keywords
* Configuring and deploying the Heroku app to host this bot



