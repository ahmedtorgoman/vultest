# Copyright [2019] [University of Aizu]
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

require 'bundler/setup'
require 'fileutils'

require 'lib/ansible/role/content/base'

module Ansible
  module Role
    module Content
      class Service < Base
        attr_reader :service

        def initialize(args)
          super(role_dir: args[:role_dir])
          @service = args[:service]
        end

        def create
          FileUtils.mkdir_p("#{role_dir}/service-#{service}/tasks")
          FileUtils.cp_r('./data/ansible/roles/service/tasks/main.yml', "#{role_dir}/service-#{service}/tasks/main.yml")

          FileUtils.mkdir_p("#{role_dir}/service-#{service}/vars")
          File.open("#{role_dir}/service-#{service}/vars/main.yml", 'w') do |vars_file|
            vars_file.puts('---')
            vars_file.puts("name: #{service}")
          end
        end
      end
    end
  end
end
