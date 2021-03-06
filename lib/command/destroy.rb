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
require 'net/ssh'
require 'tty-prompt'

require 'lib/print'

module Command
  module Destroy
    class << self
      def exec(args)
        core = args[:core]

        if core.nil?
          Print.error('Doesn\'t exist the environment')
          return
        end

        core.destroy_env
      end
    end
  end
end
