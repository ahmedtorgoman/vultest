# Copyright [2020] [University of Aizu]
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
require 'erb'
require 'fileutils'

module Ansible
  class Hosts
    def initialize(hosts_path)
      @hosts_path = hosts_path
    end

    def create(host, os_name)
      FileUtils.mkdir_p(@hosts_path)

      erb = ERB.new(File.read(ANSIBLE_HOSTS_TEMPLATE_PATH), trim_mode: 2)
      File.open("#{@hosts_path}/hosts.yml", 'w') { |f| f.puts(erb.result(binding)) }
    end
  end
end
