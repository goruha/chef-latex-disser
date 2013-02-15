#
# Author::  Rodionov Igor (<goruha@gmail.com>)
# Cookbook Name:: latex-disser
#
# Copyright 2013, Rodionov Igor.
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
packages = value_for_platform_family(
    "default" => ["zip"]
)

packages.each do |dev_pkg|
  package dev_pkg
end

zip_file = "#{Chef::Config['file_cache_path']}/disser-#{node['latex']['disser']['version']}.zip"
# Download the selected disser archive
remote_file "#{zip_file}" do
  mode 00644
  action :create
  source "#{node['latex']['disser']['mirror']}/project/disser/disser.tds/#{node['latex']['disser']['version']}/disser-#{node['latex']['disser']['version']}.tds.zip"
end

bash 'extract-disser' do
  texmf_share = value_for_platform(
      [ "debian", "ubuntu" ] => {"default" => "/usr/share/texmf"}
  )
  code <<-EOH
  unzip #{zip_file} -d #{texmf_share}
  mktexlsr
  EOH
end

