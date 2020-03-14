# Copyright [2020] [University of Aizu]
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'bundler/setup'
require 'net/ssh'

require './lib/vulenv/vulenv_linux'

class VulenvUbuntu < VulnevLinux
  def service_list
    running_service = []
    Net::SSH.start('192.168.177.177', 'vagrant', password: 'vagrant', verify_host_key: :never) do |ssh|
      cmd = ssh.exec!('sudo find / -name service | grep bin/').split("\n")[0]
      cmd = "sudo #{cmd} --status-all | grep +"
      ssh.exec!(cmd).gsub('[', '').gsub(']', '').split("\n").each { |stdout| running_service.push(stdout.split(' ')[1]) if stdout.split(' ')[0] == '+' }
    end

    running_service
  end
end
