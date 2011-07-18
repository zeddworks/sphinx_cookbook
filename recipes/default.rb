#
# Cookbook Name:: sphinx
# Recipe:: default
#
# Copyright 2011, ZeddWorks
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

case node[:platform]
when "redhat"
  execute "install rabbitmq-server rpm from URL" do
    command "rpm -Uhv http://sphinxsearch.com/files/sphinx-2.0.1-1.el5.x86_64.rpm"
    not_if "rpm -q sphinx" 
  end
when "ubuntu", "debian"
  package "sphinxsearch"
end

ruby_block "dict_dir" do
  block do
    require 'open3'
    node.set[:sphinx][:dict_dir] = Open3.popen3("aspell config dict-dir")[1].read.chomp
  end
end

cookbook_file "#{node[:sphinx][:dict_dir]}/ap.multi" do
  source "ap.multi"
  owner "nginx"
  group "nginx"
  mode "0755"
end

