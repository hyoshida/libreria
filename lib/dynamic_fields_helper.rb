module DynamicFieldsHelper
  def setup_dynamic_fields
    content_tag(:script, CoffeeScript.compile(<<-COFFEE).html_safe)
      jQuery(document).ready(->
        builder = new DynamicFieldsBuilder()

        $(document).on('click', '.add_fields', ->
          builder.add_fields(this, $(this).data('association'), $(this).data('content'))
          false
        )

        $(document).on('click', '.remove_fields', ->
          builder.remove_fields(this)
          false
        )
      )
    COFFEE
  end

  def button_to_remove_fields(name, f, options = {})
    f.hidden_field(:_destroy) + content_tag(:button, name, options.merge(class: "remove_fields #{options[:class]}"))
  end

  def button_to_add_fields(name, f, association, options = {})
    new_fields = build_fields(f, association).gsub(/"/, "'")
    content_tag(:button, name, options.merge(class: "add_fields #{options[:class]}", 'data-association' => association, 'data-content' => new_fields))
  end

  private

  def build_fields(f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new

    f.fields_for(association, new_object, child_index: "new_#{association}") do |builder|
      render("#{association.to_s.singularize}_fields", f: builder)
    end
  end
end
