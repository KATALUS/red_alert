require 'spec_helper'

describe RedAlert::Notification do
  describe '::new' do
    it 'initalizes' do
       result = RedAlert::Notification.new 'test subject', 'test body'
       result.subject.must_equal 'test subject'
       result.body.must_equal 'test body'
    end
  end

  describe '::build' do
    let(:exception) { RuntimeError.new 'explosion happened' }
    let(:subject_template) { 'BOOM! %s' }
    let(:body_template) { 'error: <%= exception.to_s %>' }
    let(:additional_data) { {} }
    subject { RedAlert::Notification.build subject_template, body_template, exception, additional_data }

    it 'has subject' do
      subject.subject.must_equal 'BOOM! explosion happened'
    end

    it 'has body' do
      subject.body.must_equal 'error: explosion happened'
    end

    describe 'without subject' do
      let(:subject_template) { nil }

      it 'has nil subject' do
        subject.subject.must_be_nil
      end
    end

    describe 'with additional data for body' do
      let(:additional_data) { { :stuff => 'in body' } }
      let(:body_template) { 'error: <%= exception.to_s %> with stuff: <%= data[:stuff] %>' }

      it 'has body' do
        subject.body.must_equal 'error: explosion happened with stuff: in body'
      end
    end
  end
end
