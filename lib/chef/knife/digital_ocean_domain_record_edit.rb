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

require 'chef/knife/digital_ocean_base'

class Chef
  class Knife
    class DigitalOceanDomainRecordEdit < Knife
      include Knife::DigitalOceanBase

      banner 'knife digital_ocean domain record edit (options)'

      option :domain,
        :short       => '-D ID',
        :long        => '--domain-id ID',
        :description => 'The domain id'

      option :record,
        :short       => '-R ID',
        :long        => '--record-id ID',
        :description => 'The record id'

      option :type,
        :short       => '-T RECORD TYPE',
        :long        => '--type RECORD TYPE',
        :description => 'The type of record'

      option :name,
        :short       => '-N RECORD NAME',
        :long        => '--name RECORD NAME',
        :description => 'The record name'

      option :data,
        :short       => '-d DATA',
        :long        => '--data DATA',
        :description => 'The record data'

      def run
        $stdout.sync = true

        validate!

        unless locate_config_value(:domain)
          ui.error("Domain cannot be empty. => -D <domain-id>")
          exit 1
        end

        unless locate_config_value(:record)
          ui.error("Record cannot be empty. => -R <record-id>")
          exit 1
        end

        unless locate_config_value(:data) || locate_config_value(:type) || locate_config_value(:name)
          ui.error("Must provide at least one value to change. => -T <record-type> => -N <record-name> -d <record-data>")
          exit 1
        end

        result = client.domains.edit_record locate_config_value(:domain),
                                            locate_config_value(:record),
                                            {
                                              :data => locate_config_value(:data),
                                              :record_type => locate_config_value(:type),
                                              :name => locate_config_value(:name)
                                            }.delete_if {|key, value| value.nil?}
        puts result.status
      end

    end
  end
end