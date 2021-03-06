#!/usr/bin/env ruby

#  This file was used to generate the 'unicode_data.c' file by parsing the
#  Unicode data file 'UnicodeData.txt' of the Unicode Character Database.
#  (from stdin, additional files are loaded directly)
#  It is included for informational purposes only and not intended for
#  production use.


#  Copyright (c) 2009 Public Software Group e. V., Berlin, Germany
#
#  Permission is hereby granted, free of charge, to any person obtaining a
#  copy of this software and associated documentation files (the "Software"),
#  to deal in the Software without restriction, including without limitation
#  the rights to use, copy, modify, merge, publish, distribute, sublicense,
#  and/or sell copies of the Software, and to permit persons to whom the
#  Software is furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
#  DEALINGS IN THE SOFTWARE.


#  This file contains derived data from a modified version of the
#  Unicode data files. The following license applies to that data:
#
#  COPYRIGHT AND PERMISSION NOTICE
#
#  Copyright (c) 1991-2007 Unicode, Inc. All rights reserved. Distributed
#  under the Terms of Use in http://www.unicode.org/copyright.html.
#
#  Permission is hereby granted, free of charge, to any person obtaining a
#  copy of the Unicode data files and any associated documentation (the "Data
#  Files") or Unicode software and any associated documentation (the
#  "Software") to deal in the Data Files or Software without restriction,
#  including without limitation the rights to use, copy, modify, merge,
#  publish, distribute, and/or sell copies of the Data Files or Software, and
#  to permit persons to whom the Data Files or Software are furnished to do
#  so, provided that (a) the above copyright notice(s) and this permission
#  notice appear with all copies of the Data Files or Software, (b) both the
#  above copyright notice(s) and this permission notice appear in associated
#  documentation, and (c) there is clear notice in each modified Data File or
#  in the Software as well as in the documentation associated with the Data
#  File(s) or Software that the data or software has been modified.
#
#  THE DATA FILES AND SOFTWARE ARE PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
#  KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
#  THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
#  INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT OR
#  CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
#  USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
#  TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
#  PERFORMANCE OF THE DATA FILES OR SOFTWARE.
#
#  Except as contained in this notice, the name of a copyright holder shall
#  not be used in advertising or otherwise to promote the sale, use or other
#  dealings in these Data Files or Software without prior written
#  authorization of the copyright holder.


$ignorable_list = File.read("DerivedCoreProperties.txt")[/# Derived Property: Default_Ignorable_Code_Point.*?# Total code points:/m]
$ignorable = []
$ignorable_list.each_line do |entry|
  if entry =~ /^([0-9A-F]+)\.\.([0-9A-F]+)/
    $1.hex.upto($2.hex) { |e2| $ignorable << e2 }
  elsif entry =~ /^[0-9A-F]+/
    $ignorable << $&.hex
  end
end

#$grapheme_boundclass_list = File.read("GraphemeBreakProperty.txt")
#$grapheme_boundclass = Hash.new("UTF8PROC_BOUNDCLASS_OTHER")
#$grapheme_boundclass_list.each_line do |entry|
#  if entry =~ /^([0-9A-F]+)\.\.([0-9A-F]+)\s*;\s*([A-Za-z_]+)/
#    $1.hex.upto($2.hex) { |e2| $grapheme_boundclass[e2] = "UTF8PROC_BOUNDCLASS_" + $3.upcase }
#  elsif entry =~ /^([0-9A-F]+)\s*;\s*([A-Za-z_]+)/
#    $grapheme_boundclass[$1.hex] = "UTF8PROC_BOUNDCLASS_" + $2.upcase
#  end
#end

#$charwidth_list = File.read("CharWidths.txt")
#$charwidth = Hash.new(0)
#$charwidth_list.each_line do |entry|
#  if entry =~ /^([0-9A-F]+)\.\.([0-9A-F]+)\s*;\s*([0-9]+)/
#    $1.hex.upto($2.hex) { |e2| $charwidth[e2] = $3.to_i }
#  elsif entry =~ /^([0-9A-F]+)\s*;\s*([0-9]+)/
#    $charwidth[$1.hex] = $2.to_i
#  end
#end

$exclusions = File.read("CompositionExclusions.txt")[/# \(1\) Script Specifics.*?# Total code points:/m]
$exclusions = $exclusions.chomp.split("\n").collect { |e| e.hex }

$excl_version = File.read("CompositionExclusions.txt")[/# \(2\) Post Composition Version precomposed characters.*?# Total code points:/m]
$excl_version = $excl_version.chomp.split("\n").collect { |e| e.hex }

#$case_folding_string = File.open("CaseFolding.txt", :encoding => 'utf-8').read
#$case_folding = {}
#$case_folding_string.chomp.split("\n").each do |line|
#  next unless line =~ /([0-9A-F]+); [CFS]; ([0-9A-F ]+);/i
#  $case_folding[$1.hex] = $2.split(" ").collect { |e| e.hex }
#end

UTF8PROC_PROPERTY_HAS_COMB_INDEX1 = 0x80000000;
UTF8PROC_PROPERTY_HAS_COMB_INDEX2 = 0x40000000;
UTF8PROC_PROPERTY_IS_COMP_EXCLUSION = 0x20000000;
UTF8PROC_PROPERTY_IS_DECOMP_COMPAT  = 0x10000000;

UTF8PROC_PROPERTY_DECOMP_LENGTH_OFFSET   = 8+14;
UTF8PROC_PROPERTY_DECOMP_MAPPING_OFFSET  = 8;
UTF8PROC_PROPERTY_COMBINING_CLASS_OFFSET  = 0;
 

$int_array = [0]
$int_array_indicies = {}

def str2c(string, prefix)
  return "0" if string.nil?
  return "UTF8PROC_#{prefix}_#{string.upcase}"
end
def ary2c(array)
  return 0 if array.nil?
  unless $int_array_indicies[array]
    $int_array_indicies[array] = $int_array.length
    array.each { |entry| $int_array << entry }
  end
  raise "Array index out of bound" if $int_array_indicies[array] >= 65535
  raise "Empty array" if array.length == 0
  return $int_array_indicies[array]
end
def ary2utf16ary(array)
  return nil if array.nil?
  return (array.flat_map { |cp| 
    if (cp <= 0xFFFF) 
      raise "utf-16 code: #{cp}" if cp & 0b1111100000000000 == 0b1101100000000000
      cp 
    else 
      temp = cp - 0x10000
      [(temp >> 10) | 0b1101100000000000, (temp & 0b0000001111111111) | 0b1101110000000000]
    end
  })
end

class UnicodeChar
  attr_accessor :code, :name, :category, :combining_class, :bidi_class,
                :decomp_type, :decomp_mapping, :decomp_mapping_utf16,
                :bidi_mirrored,
                :uppercase_mapping, :lowercase_mapping, :titlecase_mapping
  def initialize(line)
    raise "Could not parse input." unless line =~ /^
      ([0-9A-F]+);        # code
      ([^;]+);            # name
      ([A-Z]+);           # general category
      ([0-9]+);           # canonical combining class
      ([A-Z]+);           # bidi class
      (<([A-Z]*)>)?       # decomposition type
      ((\ ?[0-9A-F]+)*);  # decompomposition mapping
      ([0-9]*);           # decimal digit
      ([0-9]*);           # digit
      ([^;]*);            # numeric
      ([YN]*);            # bidi mirrored
      ([^;]*);            # unicode 1.0 name
      ([^;]*);            # iso comment
      ([0-9A-F]*);        # simple uppercase mapping
      ([0-9A-F]*);        # simple lowercase mapping
      ([0-9A-F]*)$/ix     # simple titlecase mapping
    @code              = $1.hex
    @name              = $2
    @category          = $3
    @combining_class   = Integer($4)
    @bidi_class        = $5
    @decomp_type       = $7
    @decomp_mapping    = ($8=='') ? nil :
                         $8.split.collect { |element| element.hex }
    @decomp_mapping_utf16 = decomp_mapping ? ary2utf16ary(decomp_mapping) : nil
    @bidi_mirrored     = ($13=='Y') ? true : false
    @uppercase_mapping = ($16=='') ? nil : $16.hex
    @lowercase_mapping = ($17=='') ? nil : $17.hex
    @titlecase_mapping = ($18=='') ? nil : $18.hex
  end
  def case_folding
    $case_folding[code]
  end
  def c_entry(comb1_indicies, comb2nd_minpos, comb2nd_maxpos)
    raise "need two combs indices" if comb1_indicies[code] && comb2nd_minpos[code]
    "(" <<
#    "category:#{str2c category, 'CATEGORY'};" <<
    "combining_class:#{combining_class}; " <<
    "comp_exclusion:#{($exclusions.include?(code) or $excl_version.include?(code)) ? 1 : 0}; " <<
#    "bidi_class:#{str2c bidi_class, 'BIDI_CLASS'}; " <<
    "decomp_type:#{decomp_type ? 0 : 1}; " <<
    "decomp_length:#{decomp_mapping_utf16 ? decomp_mapping_utf16.length : 0 }; " <<    
    "decomp_mapping:#{ary2c decomp_mapping_utf16}; " <<
#    "casefold_mapping:#{ary2c case_folding}; " <<
#    "uppercase_mapping:#{uppercase_mapping or -1}; " <<
#    "lowercase_mapping:#{lowercase_mapping or -1}; " <<
#    "titlecase_mapping:#{titlecase_mapping or -1}; " <<
    "comb_index:#{comb1_indicies[code] ? comb1_indicies[code] : 
                  comb2nd_minpos[code] ? 0x8000 | (comb2nd_minpos[code] << 8) | (comb2nd_maxpos[code])  : 0}; " <<
#    "bidi_mirrored:#{bidi_mirrored}; " <<
#    "ignorable:#{$ignorable.include?(code)}; " <<
#    "control_boundary:#{%W[Zl Zp Cc Cf].include?(category) and not [0x200C, 0x200D].include?(category)}; " <<
#    "boundclass#{$grapheme_boundclass[code]}; " <<
#    "charwidth:#{$charwidth[code]};\n"
    ")"
  end
  def a_entry(comb1_indicies, comb2nd_minpos, comb2nd_maxpos)
    raise "need two combs indices" if comb1_indicies[code] && comb2nd_minpos[code]
    array = [
      (comb1_indicies[code] ? UTF8PROC_PROPERTY_HAS_COMB_INDEX1 : 0) |
      (comb2nd_minpos[code] ? UTF8PROC_PROPERTY_HAS_COMB_INDEX2 : 0) |
      (($exclusions.include?(code) or $excl_version.include?(code)) ? UTF8PROC_PROPERTY_IS_COMP_EXCLUSION : 0) |
      (decomp_type ? UTF8PROC_PROPERTY_IS_DECOMP_COMPAT : 0) |
      (decomp_mapping_utf16 ? decomp_mapping_utf16.length << UTF8PROC_PROPERTY_DECOMP_LENGTH_OFFSET : 0) |
      (ary2c(decomp_mapping_utf16) << UTF8PROC_PROPERTY_DECOMP_MAPPING_OFFSET) |
      (combining_class << UTF8PROC_PROPERTY_COMBINING_CLASS_OFFSET) 
    ];
    if (comb1_indicies[code]) 
      array << comb1_indicies[code] 
    else if (comb2nd_minpos[code]) 
      array << ((comb2nd_minpos[code] << 8) | (comb2nd_maxpos[code]));
    end; end;
    return array
  end  
end

chars = []
char_hash = {}

while gets
  if $_ =~ /^([0-9A-F]+);<[^;>,]+, First>;/i
    first = $1.hex
    gets
    char = UnicodeChar.new($_)
    raise "No last character of sequence found." unless
      $_ =~ /^([0-9A-F]+);<([^;>,]+), Last>;/i
    last = $1.hex
    name = "<#{$2}>"
    for i in first..last
      char_clone = char.clone
      char_clone.code = i
      char_clone.name = name
      char_hash[char_clone.code] = char_clone
      chars << char_clone
    end
  else
    char = UnicodeChar.new($_)
    char_hash[char.code] = char
    chars << char
  end
end

comb1st_indicies = {}
comb2nd_indicies = {}
comb2nd_minpos = {}
comb2nd_maxpos = {}
comb_array = []
comb_array_compressed = []

comb1st_indicies[0] = 0
comb_array[0] = []
comb_array_compressed[0] = []

chars.each do |char|
  if !char.nil? and char.decomp_type.nil? and char.decomp_mapping and
      char.decomp_mapping.length == 2 and !char_hash[char.decomp_mapping[0]].nil? and
      char_hash[char.decomp_mapping[0]].combining_class == 0 and
      not $exclusions.include?(char.code)
    unless comb1st_indicies[char.decomp_mapping[0]]
      comb1st_indicies[char.decomp_mapping[0]] = comb1st_indicies.keys.length
    end
    unless comb2nd_indicies[char.decomp_mapping[1]]
      comb2nd_indicies[char.decomp_mapping[1]] = comb2nd_indicies.keys.length
    end
    comb_array[comb1st_indicies[char.decomp_mapping[0]]] ||= []
    raise "Duplicate canonical mapping" if
      comb_array[comb1st_indicies[char.decomp_mapping[0]]][
      comb2nd_indicies[char.decomp_mapping[1]]]
    comb_array[comb1st_indicies[char.decomp_mapping[0]]][comb2nd_indicies[char.decomp_mapping[1]]] = char.code
    raise "1st index too high" if comb1st_indicies[char.decomp_mapping[0]] >= 0x8000

    comb_array_compressed[comb1st_indicies[char.decomp_mapping[0]]] ||= []    
    temp_index = comb_array_compressed[comb1st_indicies[char.decomp_mapping[0]]].length
    unless comb2nd_minpos[char.decomp_mapping[1]]
      comb2nd_minpos[char.decomp_mapping[1]] = comb_array_compressed[comb1st_indicies[char.decomp_mapping[0]]].length
      comb2nd_maxpos[char.decomp_mapping[1]] = comb_array_compressed[comb1st_indicies[char.decomp_mapping[0]]].length
    end
    comb2nd_minpos[char.decomp_mapping[1]] = temp_index if !comb2nd_minpos[char.decomp_mapping[1]] || temp_index < comb2nd_minpos[char.decomp_mapping[1]] 
    comb2nd_maxpos[char.decomp_mapping[1]] = temp_index if !comb2nd_maxpos[char.decomp_mapping[1]] || temp_index > comb2nd_maxpos[char.decomp_mapping[1]]     
    comb_array_compressed[comb1st_indicies[char.decomp_mapping[0]]] << char.decomp_mapping[1] << char.code
    raise "2nd index too high" if comb2nd_minpos[char.decomp_mapping[1]] > 64 || comb2nd_maxpos[char.decomp_mapping[1]] > 64
  end
end

properties_indicies = {}
properties = []

#create an empty record (code 0000 seems to be comb_exclusive which does not help)
a_entry = UnicodeChar.new("0001;<control>;Cc;0;BN;;;;;N;NULL;;;;").a_entry(comb1st_indicies, comb2nd_minpos, comb2nd_maxpos)
properties_indicies[a_entry] = properties.length
a_entry.each { |entry| properties << entry }

chars.each do |char|
  a_entry = char.a_entry(comb1st_indicies, comb2nd_minpos, comb2nd_maxpos)
  unless properties_indicies[a_entry]
    properties_indicies[a_entry] = properties.length
    a_entry.each { |entry| properties << entry }
  end
end

stage1 = []
stage2 = []
for code in 0...0x110000
  next unless code % 0x100 == 0
  stage2_entry = []
  for code2 in code...(code+0x100)
    if char_hash[code2]
      stage2_entry << (properties_indicies[char_hash[code2].a_entry(comb1st_indicies, comb2nd_minpos, comb2nd_maxpos)])
    else
      stage2_entry << 0
    end
  end
  old_index = stage2.index(stage2_entry)
  if old_index
    stage1 << (old_index * 0x100)
  else
    stage1 << (stage2.length * 0x100)
    stage2 << stage2_entry
  end
end

$stdout << "const utf8proc_sequences:Array[0.." << $int_array.length - 1 << "] of word=( \n "
i = 0
$int_array[0...-1].each do |entry|
  i += 1
  if i == 8
    i = 0
    $stdout << "\n  "
  end
  $stdout << entry << ", "
end
$stdout << $int_array.last << ");\n\n"

$stdout << "utf8proc_stage1table:Array[0.." << stage1.length - 1 << "] of word=( \n "
i = 0
stage1[0...-1].each do |entry|
  i += 1
  if i == 8
    i = 0
    $stdout << "\n  "
  end
  $stdout << entry << ", "
end
$stdout << stage1.last << ");\n\n"

stage2flat = stage2.flatten
$stdout << "utf8proc_stage2table:Array[0.." << stage2flat.length - 1 << "] of word=(\n"
i = 0
stage2flat[0...-1].each do |entry|
  i += 1
  if i == 8
    i = 0
    $stdout << "\n  "
  end
  $stdout << entry << ", "
end
$stdout << stage2flat.last << ");\n\n"

$stdout << "utf8proc_properties:Array[0.." << properties.length - 1 << "] of DWORD=(\n"
first = true
i = 0
properties.each { |e|
  i += 1
  $stdout << ", " if !first
  if i == 8
    i = 0
    $stdout << "\n  "
  end
  $stdout << "$" << e.to_s(16)
  first = false
}
$stdout << ");\n\n"

$stdout << "utf8proc_combinations_starts:Array[0.." << comb1st_indicies.keys.length  << "] of word=(\n  "
i = 0
cumoffset = 0
comb1st_indicies.keys.sort.each_index do |a|
  i += 1
  if i == 8
    i = 0
    $stdout << "\n  "
  end
  $stdout << cumoffset << ", "
  cumoffset += comb_array_compressed[a].length
  raise "too high index" if cumoffset > 65535
end
$stdout << cumoffset << ");\n\n"

$stdout << "utf8proc_combinations:Array[0.." << cumoffset << "] of longint=(\n  "
i = 0
comb1st_indicies.keys.sort.each_index do |a|
  comb_array_compressed[a].each do |b| 
    i += 1
    if i == 8
      i = 0
      $stdout << "\n  "
    end
    $stdout << b << ", "
  end
end
$stdout << "0);\n\n"

