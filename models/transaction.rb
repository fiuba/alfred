module Database
	module Transaction
		# 
		# This method defines a transaction which can potentially develop
		# object updates through the datamapper model.
		#
		# It automaticaly invoke a block with two parameters: 
		# 	tx 		param: it identifies the transaction itself
		# 	erros param: it is a list which contains errors arose during 
		# 							 tx execution.
		#
		# When the block execution finalizes the transaction
		# will be commited if not errors happened, otherwise transaction
		# will be rolledback.
		#
		# WARINIG
		# If you use this method inside a controller you musn't include 
		# redirect invokation inside this block.	
		#
		#
		def self.within(*block) 
			errors = []
			to_raise = nil
			repository = DataMapper.repository(:default)
			tx = DataMapper::Transaction.new( repository )
			tx.begin()
			repository.adapter.push_transaction(tx)

			begin
				yield tx, errors
			rescue Exception => e
				to_raise = e
				errors << e
			end

			if errors.empty?
				tx.commit()
			else
				tx.rollback()
			end

			tx = repository.adapter.pop_transaction

			raise to_raise if to_raise
		end
	end
end
