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

require 'bundler/setup'
require 'fileutils'

require './lib/ansible/role/content/base'

module Ansible
  module Role
    module Content
      module Software
        class Base < Content::Base
          attr_reader :software

          def initialize(args)
            super(role_dir: args[:role_dir])
            @software = args[:software]
          end

          def create
            create_tasks
            create_vars
          end

          private

          def create_tasks
            raise NotImplementedError
          end

          def create_vars
            raise NotImplementedError
          end

          def option_user
            content = nil
            if software.key?('user') && !software['user'].nil?
              content = "user: #{software['user']}\n"
              content << "user_dir: /home/#{software['user']}\n"
            else
              content = "user: test\n"
              content << "user_dir: /home/test\n"
            end
            content
          end
        end
      end
    end
  end
end
