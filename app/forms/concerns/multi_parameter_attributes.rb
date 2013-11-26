module MultiParameterAttributes
  def self.included(base)
    base.class_eval do
      def self.form_multi_parameter(key, klass)
        @mapping ||= {}
        @mapping.merge!({key => klass})
      end

      def self.form_multi_parameters
        @mapping
      end
    end
  end

  def initialize(attributes = {})
    self.attributes = attributes
  end

  def attributes
    Hash[instance_variable_names.map{|v| [v[1..-1].to_sym, instance_variable_get(v)]}]
  end

  def attributes=(attrs)
    multi_parameter_attributes = []
    attrs.each do |name, value|
      return if attrs.blank?
      if name.to_s.include?("(")
        multi_parameter_attributes << [ name, value ]
      else
        writer_method = "#{name.to_s}="
        if respond_to?(writer_method)
          self.send(writer_method, value)
        else
          begin
            self[name.to_s] = value
          rescue
            # 関係ないattributesが来たらスルー
          end
        end
      end
    end
  
    assign_multiparameter_attributes(multi_parameter_attributes)
  end
  
  def assign_multiparameter_attributes(pairs)
    execute_callstack_for_multiparameter_attributes(
      extract_callstack_for_multiparameter_attributes(pairs)
    )
  end
  
  def execute_callstack_for_multiparameter_attributes(callstack)
    callstack.each do |name, values_with_empty_parameters|
      # in order to allow a date to be set without a year, we must keep the empty values.
      # Otherwise, we wouldn't be able to distinguish it from a date with an empty day.
      values = values_with_empty_parameters.reject(&:nil?)

      if values.any?
        klass = self.class.form_multi_parameters[name.to_sym]
        raise ArgumentError, "Unknown klass #{name}" if klass.nil?
        
        value = if Time == klass
          Time.zone.local(*values)
        elsif Date == klass
          begin
            values = values_with_empty_parameters.collect do |v| v.nil? ? 1 : v.to_i end
            Date.new(*values)
          rescue ArgumentError => ex # if Date.new raises an exception on an invalid date
            Time.zone.local(*values).to_date # we instantiate Time object and convert it back to a date thus using Time's logic in handling invalid dates
          end
        else
          klass.new(*values)
        end
        writer_method = "#{name}="
        if respond_to?(writer_method)
          self.send(writer_method, value)
        else
          self[name.to_s] = value
        end
      end
    end
  end
  
  def extract_callstack_for_multiparameter_attributes(pairs)
    attributes = { }
  
    for pair in pairs
      multiparameter_name, value = pair
      attribute_name = multiparameter_name.split("(").first
      attributes[attribute_name] = [] unless attributes.include?(attribute_name)
  
      attributes[attribute_name] << [ find_parameter_position(multiparameter_name), value ]
    end
  
    attributes.each { |name, values| attributes[name] = values.sort_by{ |v| v.first }.collect { |v| v.last } }
  end
  
  def find_parameter_position(multiparameter_name)
    multiparameter_name.scan(/\(([0-9]*).*\)/).first.first
  end
  
end
