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

require 'open3'
require 'tty-prompt'

require_relative '../ui'

module VulenvParams
  private

  def start_vulenv
    VultestUI.tty_spinner_begin('Start up')
    _stdout, _stderr, status = Open3.capture3('vagrant up')
    if status.exitstatus.zero? then VultestUI.tty_spinner_end('success')
    else VultestUI.tty_spinner_end('error')
    end
  end

  def reload_vulenv
    VultestUI.tty_spinner_begin('Reload')
    _stdout, _stderr, status = Open3.capture3('vagrant reload')
    if status.exitstatus.zero? then VultestUI.tty_spinner_end('success')
    else VultestUI.tty_spinner_end('error')
    end
  end

  def hard_setup
    @vulenv_config['construction']['hard_setup']['msg'].each { |msg| VultestUI.print_vultest_message('caution', msg) }
    Open3.capture3('vagrant halt')

    p = TTY::Prompt.new
    p.keypress('Please press enter key, when ready', keys: [:return])

    start_vulenv
  end
end
