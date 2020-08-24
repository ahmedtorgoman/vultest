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
require 'fileutils'

module Ansible
  module Roles
    module Database
      class User
        attr_reader :path

        def initialize(args)
          @role_dir = args[:role_dir]
          @name = args[:name]
          @config = args[:config]
        end

        def create
          FileUtils.mkdir_p("#{@role_dir}/#{@name}.database.user")

          FileUtils.cp_r(
            "#{ANSIBLE_ROLES_TEMPLATE_PATH}/database/user/tasks",
            "#{@role_dir}/#{@name}.database.user"
          )

          FileUtils.cp_r(
            "#{ANSIBLE_ROLES_TEMPLATE_PATH}/database/user/vars",
            "#{@role_dir}/#{@name}.database.user"
          )

          ::File.open("#{@role_dir}/#{@name}.database.user/vars/main.yml", 'a') do |f|
            f.puts("user: #{@config['user']}")
            f.puts("password: #{@config['password']}")
            f.puts("host: #{@config['host']}")
            f.puts("priv: \"#{@config['priv']}\"")
            f.puts("login_user: #{@config['login_user']}")
            f.puts("login_password: #{@config['login_password']}")
            f.puts("config_file: #{@config['config_file']}")
          end

          @path = "#{@name}.database.user"
        end
      end
    end
  end
end
