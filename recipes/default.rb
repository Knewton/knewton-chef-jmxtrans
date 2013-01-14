#
# Cookbook Name:: knewton-chef-jmxtrans
# Description:: Install jmxtrans from the knewton github
# Recipe:: default
# Author:: Tim Dysinger
#
#
# Copyright 2012, Knewton, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


#############################################
# purge an older package of jmxtrans if any #
#############################################

package 'jmxtrans' do
  action :purge
end

#######################
# create user & group #
#######################

group 'jmxtrans' do
  system true
  gid 502
  not_if 'getent group jmxtrans'
end

user 'jmxtrans' do
  system true
  uid 502
  gid 'jmxtrans'
  password '!'
  shell '/bin/bash'
  home '/home/jmxtrans'
  not_if 'getent passwd jmxtrans'
end

#######################
# install dirs & jars #
#######################

[ node["jmxtrans"]["etc"], node["jmxtrans"]["lib"] ].each do |dir|
  directory dir
end

directory node["jmxtrans"]["log"] do
  group 'jmxtrans'
  owner 'jmxtrans'
end

node["jmxtrans"]["jar_name"] =
  "jmxtrans-#{node["jmxtrans"]["version"]}-standalone.jar"
node["jmxtrans"]["jar_path"] =
  "#{node["jmxtrans"]["lib"]}/#{node["jmxtrans"]["jar_name"]}"
node["jmxtrans"]["jar_url"] =
  "#{node["jmxtrans"]["url"]}/#{node["jmxtrans"]["jar_name"]}"

remote_file node["jmxtrans"]["jar_path"] do
  source node["jmxtrans"]["jar_url"]
  mode '0644'
end

#################
# runit service #
#################

include_recipe 'java'

execute 'sv hup jmxtrans' do
  action :nothing
end

runit_service 'jmxtrans' do
  options({
            'jar'       => node["jmxtrans"]["jar_path"],
            'etc'       => node["jmxtrans"]["etc"],
            'log'       => node["jmxtrans"]["log"],
            'log_level' => node["jmxtrans"]["log_level"]
          })
end
