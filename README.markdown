Welcome to Bitflow
==================

To startup on your machine

prerequsites
------------
1. Install mysql (http://dev.mysql.com/doc/refman/5.1/en/installing.html)
2. Install rvm (http://rvm.beginrescueend.com/)
3. rvm install ruby-1.9.2-p180
4. postfix installed and running on your machine.(or any MTA) This is used to send login confirmation email(https://help.ubuntu.com/community/Postfix). It's installed by default on MacOS X

Application
===========
0. cd to BitFlow folder( If you are already in the folder, cd.. and cd Bitflow). You will be asked to accept a script. type yes
1. gem install bundler && bundle install
2. rake db:create
3. rake db:migrate
4. rails server
5. Navigate to http://localhost:3000

Deployment
===========

Staging

*cap staging deploy* will deploy the current code to the staging. Make sure you push to the repository before

