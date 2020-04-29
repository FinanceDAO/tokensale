// App.js
import React, { useState }from 'react'
import { useAragonApi } from '@aragon/api-react'
import { Main, Header, Button, IconPlus, Tag, TextInput } from '@aragon/ui'

function App() {
  const { api, appState } = useAragonApi()
  const { tokenManager, isSyncing } = appState
  const [amount, setAmount] = useState('')
  return (
    <Main>
      <Header
        primary={
          <>
            Token Sale   
            <Tag mode="identifier">TKN</Tag>
          </>
        }
        secondary={
          <Button mode="strong" label="Buy tokens" icon={<IconPlus />} />
        }
      />
      <div>
        Token Manager: {amount}
      </ div>
      <div>
        Vault: {amount}
      </div>
      <div>
        Rate: {amount}
      </div>
      <div>
        Hard Cap: {amount}
      </div>
      <div>
        Tokens Remaining: {amount}
      </div>
      <div>
        WEI Raised: {amount}
      </div>
      <div>
        ETH: {amount}
      </div>
      <div>
        TKN: {amount}
      </div>
      <TextInput
        value={amount}
        onChange={event => {
          setAmount(event.target.value)
        }}
      />
    </Main>
  )
}

export default App