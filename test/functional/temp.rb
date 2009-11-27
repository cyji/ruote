
%w[

  ft_0
  ft_1
  ft_2

  eft_0
  eft_1
  eft_2
  eft_3
  eft_4
  eft_5
  eft_6
  eft_7
  eft_8
  eft_9

].collect { |prefix|
  Dir[File.join(File.dirname(__FILE__), "#{prefix}_*.rb")].first
}.each { |file|
  require(file)
}

