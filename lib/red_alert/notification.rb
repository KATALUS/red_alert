require 'erb'

module RedAlert
  class Notification
    attr_reader :subject, :body

    def initialize(subject, body)
      @subject = subject
      @body = body
    end

    class << self
      def build(subject_template, body_template, exception, data = {})
        subject = compile_subject subject_template, exception
        body = compile_body body_template, exception, data
        self.new subject, body
      end

      private

      def compile_subject(template, exception)
        template % exception unless template.nil?
      end

      def compile_body(template, exception, data)
        ERB.new(template).result binding
      end
    end
  end
end
