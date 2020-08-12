# frozen_string_literal: true

require 'digest/md5'

pp Digest::MD5.file('sample/file/data.dat').to_s
