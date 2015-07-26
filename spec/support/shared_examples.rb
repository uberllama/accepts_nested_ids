shared_examples "a proper gentleman" do

  describe 'association_ids_attr' do
    it 'is defined' do
      expect(record.respond_to?(association_ids_attr)).to eq true
    end

    describe 'data retrieval' do
      context 'when instance variable set' do
        before(:each) do
          record.send("#{association_ids_attr}=", [1])
        end

        it 'returns the set IDs' do
          expect(record.send(association_ids_attr)).to eq [1]
        end
      end

      context 'when instance variable not set' do
        before(:each) do
          allow(record).to receive(association_attr).and_return(association)
        end

        context 'when association is loaded' do
          let(:association) { double('association', loaded?: true) }

          it 'returns mapped IDs' do
            expect(association).to receive(:map)
            record.send(association_ids_attr)
          end
        end

        context 'when association is not loaded' do
          let(:association) { double('association', loaded?: false) }

          it 'returns plucked IDs from the database' do
            expect(association).to receive(:pluck)
            record.send(association_ids_attr)
          end
        end
      end
    end
  end

  describe 'association_ids_attr=' do
    before(:each) do
      record.send("#{association_ids_attr}=", [1])
    end

    it 'is defined' do
      expect(record.respond_to?("#{association_ids_attr}=")).to eq true
    end

    it 'sets accompanying instance variable' do
      expect(record.instance_variable_get("@#{association_ids_attr}")).to eq [1]
    end

    it 'adds attr changes to changed_attributes' do
      expect(record.changed_attributes.has_key?(association_ids_attr)).to eq true
    end
  end

  describe '#save_nested_id_associations' do
    context 'when instance variable is set' do
      let(:associations) { double('associations') }

      before(:each) do
        record.send("#{association_ids_attr}=", [1])
        expect(association_class_name.constantize).to receive(:where).with(id: [1]).and_return(associations)
      end

      it 'calls save on nested records' do
        expect(record).to receive("#{association_attr}=").with(associations)
        record.save_nested_id_associations
      end
    end

    context 'when instance variable is not set' do
      it 'does not call save' do
        expect(record).not_to receive("#{association_attr}=")
        record.save_nested_id_associations
      end
    end
  end

end
