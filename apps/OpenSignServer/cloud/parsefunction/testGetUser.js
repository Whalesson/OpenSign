async function testGetUser(request) {
  console.log('=== testGetUser called ===');
  
  try {
    // Teste 1: Buscar sem includes
    console.log('Test 1: Simple query without includes');
    const query1 = new Parse.Query('contracts_Users');
    query1.equalTo('Email', 'whalessonwmmuniz@gmail.com');
    const result1 = await query1.first({ useMasterKey: true });
    console.log('Result 1:', result1 ? 'Found' : 'Not found');
    
    if (!result1) {
      return { error: 'User not found in contracts_Users' };
    }
    
    // Teste 2: Buscar com includes
    console.log('Test 2: Query with includes');
    const query2 = new Parse.Query('contracts_Users');
    query2.equalTo('Email', 'whalessonwmmuniz@gmail.com');
    query2.include('TenantId');
    query2.include('UserId');
    query2.include('CreatedBy');
    const result2 = await query2.first({ useMasterKey: true });
    console.log('Result 2:', result2 ? 'Found with includes' : 'Not found');
    
    // Retornar dados
    return {
      success: true,
      objectId: result2.id,
      email: result2.get('Email'),
      name: result2.get('Name'),
      role: result2.get('UserRole'),
      hasTenant: !!result2.get('TenantId'),
      hasUser: !!result2.get('UserId'),
      hasCreatedBy: !!result2.get('CreatedBy')
    };
    
  } catch (err) {
    console.log('=== Error in testGetUser ===');
    console.log('Error:', err);
    console.log('Error message:', err?.message);
    console.log('Error code:', err?.code);
    console.log('Error stack:', err?.stack);
    return {
      error: err?.message || 'Unknown error',
      code: err?.code
    };
  }
}

export default testGetUser;
