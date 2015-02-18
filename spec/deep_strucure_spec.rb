require 'spec_helper'

RSpec.describe APIConfig::DeepStruct do
  let!(:hash) { { a: :a, b: { c: { d: :e }}} }

  subject { APIConfig::DeepStruct.new(hash) }

  describe '#to_h' do
    it 'works' do
      expect(subject.to_h).to eq(hash)
    end
  end

  describe '#path_for' do
    it 'works' do
      expect(subject.path_for(:a)).to     eq("#{APIConfig.env}.a")
      expect(subject.b.c.path_for(:d)).to eq("#{APIConfig.env}.b.c.d")
    end
  end

  describe '#method_missing' do
    it 'works' do
      expect(subject.a).to     eq(:a)
      expect(subject.b.c.d).to eq(:e)
      expect(subject.b.c).to   eq(described_class.new(d: :e))
    end
  end
end
