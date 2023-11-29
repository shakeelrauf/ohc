# frozen_string_literal: true

module MultiselectHelper
  def multiselect(builder, attribute, values, label, id)
    render 'shared/multiselect', builder: builder,
                                 attribute: attribute,
                                 values: values,
                                 label: label,
                                 id: id
  end
end
