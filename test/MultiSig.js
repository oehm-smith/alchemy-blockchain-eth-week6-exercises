const { assert } = require('chai');
describe('MultiSig', function () {
    describe('stage 1', () => {
        let contract;
        let _required = 2;
        before(async () => {
            accounts = await ethers.provider.listAccounts();
            const MultiSig = await ethers.getContractFactory("MultiSig");
            contract = await MultiSig.deploy(accounts.slice(0, 3), _required);
            await contract.deployed();
        });

        it('should set an array of owners', async function () {
            let firstOwner = await contract.callStatic.owners(0);
            let lastOwner = await contract.callStatic.owners(2);
            assert.equal(accounts[2], lastOwner);
            assert.equal(accounts[0], firstOwner);
        });

        it('should set the number of required confirmations', async function () {
            const required = await contract.required();
            assert.equal(_required, required);
        });
    });
    describe('stage 2', () => {
        let contract;
        let accounts;
        let MultiSig;
        before(async () => {
            MultiSig = await ethers.getContractFactory("MultiSig");
            accounts = await ethers.provider.listAccounts();
        });

        describe('for a valid multisig', () => {
            let _required = 2;
            before(async () => {
                contract = await MultiSig.deploy(accounts.slice(0, 3), _required);
                await contract.deployed();
            });

            it('should set an array of owners', async () => {
                let firstOwner = await contract.callStatic.owners(0);
                let lastOwner = await contract.callStatic.owners(2);
                assert.equal(accounts[2], lastOwner);
                assert.equal(accounts[0], firstOwner);
            });

            it('should set required confirmations', async () => {
                let required = await contract.callStatic.required();
                assert.equal(_required, required.toNumber());
            });
        });
        describe('for a multisig with no owners', () => {
            it('should revert', async () => {
                await expectThrow(MultiSig.deploy([], 1));
            });
        });

        describe('for a multisig with no required confirmations', () => {
            it('should revert', async () => {
                await expectThrow(MultiSig.deploy(accounts.slice(0, 3), 0));
            });
        });

        describe('for a multisig with more required confirmations than owners', () => {
            it('should revert', async () => {
                await expectThrow(MultiSig.deploy(accounts.slice(0, 3), 4));
            });
        });
    });
});

async function expectThrow(promise) {
    const errMsg = 'Expected throw not received';
    try {
        await promise;
    } catch (err) {
        return;
    }
    assert(false, errMsg);
}
