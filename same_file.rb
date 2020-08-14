# frozen_string_literal: true

require 'yaml'
require 'find'
require 'fileutils'

# 検索結果保存用の配列変数
same_files_pair = []
added_files = []

# 設定ファイル読み込み
target_directory = YAML.load_file('target_directory.yaml')
target_files = Find.find(target_directory)

# 前回の検索結果を読み込み
same_files_pair = YAML.load_file('same_files_pair.yaml') if File.exist?('same_files_pair.yaml')
added_files = YAML.load_file('added_files.yaml') if File.exist?('added_files.yaml')

# 検索
target_files.each do |src|
  target_files.each do |cmp|
    next unless File.file?(cmp) # ファイル以外は除外
    next unless File.file?(src) # ファイル以外は除外
    next if src == cmp # 同じファイル名は除外
    next if added_files.include?(cmp) # すでに検査済ファイルは除外

    if File.zero?(cmp)
      # ファイルが空なら、ファイルを記憶
      same_files_pair.push([cmp, ''])
      added_files.push(cmp)
      next # 次のファイルへ
    end

    next if added_files.include?(src) # すでに検査済ファイルは除外
    next unless FileUtils.cmp(src, cmp) # 内容が異なるファイルは除外

    # ファイル名が異なり、内容が同じファイルを記憶
    same_files_pair.push([src, cmp])
    added_files.push(src)
    added_files.push(cmp)
  end
end

# 検索結果保存
File.open('same_files_pair.yaml', 'w') { |f| YAML.dump(same_files_pair, f) }
File.open('added_files.yaml', 'w') { |f| YAML.dump(added_files, f) }

# 削除
same_files_pair.each do | same_file |
  if same_file[1] == ''
    puts("This file is empty. :#{same_file[0]}")
    puts('Do you want to DELETE this file ? [y/n]')
    answer = gets.strip
    if answer == 'y'
      File.delete(same_file[0])
      puts('This file has been deleted.')
    else
      puts('skipped.')
    end
  else
    puts('same 2 files are')
    puts("1:#{same_file[0]}")
    puts("2:#{same_file[1]}")
    puts('Which do you want to delete ? [1/2]')
    answer = gets.strip
    if answer == '1'
      File.delete(same_file[0])
      puts('file1 deleted.')
    elsif answer == '2'
      File.delete(same_file[1])
      puts('file2 deleted.')
    else
      puts('skipped.')
    end
  end
end

puts('finished.')
