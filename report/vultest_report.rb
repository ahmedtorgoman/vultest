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

require_relative '../db'
require_relative '../utility'

module VultestReport

  def report(cve, test_dir, config_path)
    File.open("#{test_dir}/report.md", "w") do |report_file|
      report_file.puts("# Vultest Report\n\n")

      report_file.puts("## Target Host\n\n")
      vulenv_config = YAML.load_file(config_path[:vulenv])

      if vulenv_config['construction'].key?('vul_software')
        report_file.puts("### Vulnerable Software\n")
        report_file.puts("#{vulenv_config['construction']['vul_software']['name']} : #{vulenv_config['construction']['vul_software']['version']}\n")
      end
      report_file.puts("\n")

      if vulenv_config['construction']['os']['vulnerability'] then report_file.puts("### Vulnerable Software\n")
      else report_file.puts("### Operating System\n")
      end
      report_file.puts("#{vulenv_config['construction']['os']['name']} : #{vulenv_config['construction']['os']['version']}")
      report_file.puts("\n")

      if vulenv_config['construction'].key?('related_software')
        report_file.puts('### Related Software')
        vulenv_config['construction']['related_software'].each { |software| report_file.puts("- #{software['name']} : #{software['version']}\n") }
      end
      report_file.puts("\n")

      attack_config = YAML.load_file(config_path[:attack])
      report_file.puts("## Attack Method\n\n")

      if attack_config.key?('metasploit_module')
        report_file.puts("### Metasploit\n\n")
        attack_methods = attack_config['metasploit_module']
        attack_methods.each do |attack_method|
          report_file.puts("#### Module Name : #{attack_method['module_name']}\n")
          attack_method['options'].each { |option| report_file.puts("- #{option['name']} : #{option['var']}\n") }
          report_file.puts("\n")
        end
      end
      report_file.puts("\n")

      cve_info = DB.get_cve_info(cve)
      unless cve_info['description'].nil?
        for str_range in 1..cve_info['description'].size/100
          new_line_place = cve_info['description'].index(" ", str_range * 100) + 1
          cve_info['description'].insert(new_line_place, "\n    ")
        end
      end
      report_file.puts("## CVE Description\n")
      report_file.puts("#{cve_info['description']}\n")
      report_file.puts("\n")

      report_file.puts("## Affect Software Version (CPE)\n")
      cpe = DB.get_cpe(cve)
      cpe.each do |cpe_info|
        output_cpe_info = ''
        cpe_info.each_char do |c|
          if c == '*' then output_cpe_info = output_cpe_info + '\\' + c
          else output_cpe_info = output_cpe_info + c
          end
        end
        report_file.puts("- #{output_cpe_info}")
      end
      report_file.puts("\n")
    end

    parsed = TTY::Markdown.parse_file("#{test_dir}/report.md")
    puts parsed

  end
end
