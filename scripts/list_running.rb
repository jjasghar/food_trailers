#!/usr/bin/env ruby

require 'aws-sdk'
require 'json'

setup = JSON.load(File.read('setup.json'))

Aws.config[:credentials] = Aws::Credentials.new(setup['AccessKeyId'], setup['SecretAccessKey'])

ec2 = Aws::EC2::Client.new(region: 'us-west-2')

a = ec2.describe_instances.to_a[0][0]
a.each do |reservation|
  reservation.instances.each do |instance|
    public_ips = instance.network_interfaces.each_with_object([]) do |int, memo|
      memo << int.association.public_ip unless int.association.nil?
    end

    tags = instance.tags.map { |tag| tag.value }

    next unless tags.find { |tag| tag =~ /PUTYOURTAGHERE/ }

    puts "#{instance.instance_id} | #{tags.join(', ')} | #{public_ips.join(', ')}"
  end
end
