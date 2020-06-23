FactoryBot.define do
  factory :document do
    association :user
    association :category
    name {Faker::Book.title}
    doc {Rack::Test::UploadedFile.new("#{Rails.root}/tmp/sample.pdf", "application/pdf")}
    status {Document.statuses[:wait]}

    trait :draft_doc do
      status {Document.statuses[:draft]}
    end
    trait :approved_doc do
      status{Document.statuses[:approved]}
    end
    trait :ban_doc do
      status{Document.statuses[:ban]}
    end
    trait :deleted_doc do
      status{Document.statuses[:deleted]}
    end
  end
end
