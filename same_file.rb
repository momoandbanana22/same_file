# frozen_string_literal: true

require 'find'
require 'fileutils'

same_files_pair = []
added_files = []

target_files = Find.find('D:\Download\video')

target_files.each do |src|
  target_files.each do |cmp|
    next unless File.file?(cmp) # ファイル以外は除外
    next unless File.file?(src) # ファイル以外は除外
    next if src == cmp # 同じファイル名は除外
    next if added_files.include?(src) # すでに検査済ファイルは除外
    next if added_files.include?(cmp) # すでに検査済ファイルは除外
    next unless FileUtils.cmp(src, cmp) # 内容が違うファイルは除外

    # ファイル名が異なり、内容が同じファイルを記憶
    same_files_pair.push([src, cmp])
    added_files.push(src)
    added_files.push(cmp)
  end
end

pp same_files
