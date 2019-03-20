ActiveSupport::Inflector.inflections(:en) do |inflect|
    inflect.irregular 'curriculum_vitae', 'curricula_vitae'
end

class CurriculumVitae < Document
  belongs_to :repayment, optional: true
end
