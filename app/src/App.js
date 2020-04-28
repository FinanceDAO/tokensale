import React from 'react'
import { useAragonApi } from '@aragon/api-react'
import {
  Box,
  Button,
  GU,
  Header,
  IconMinus,
  IconPlus,
  Main,
  SyncIndicator,
  Tabs,
  Text,
  textStyle,
} from '@aragon/ui'
import styled from 'styled-components'

function App() {
  const { api, appState, path, requestPath } = useAragonApi()
  const { tokenManager, isSyncing } = appState
  const [tm, setTM] = useState('')
  const [v, setVault] = useState('')


  const pathParts = path.match(/^\/tab\/([0-9]+)/)
  const pageIndex = Array.isArray(pathParts)
    ? parseInt(pathParts[1], 10) - 1
    : 0

  return (
    <Main>
      {isSyncing && <SyncIndicator />}
      <Header
        primary="Token Sale"
        secondary={
          <Text
            css={`
              ${textStyle('title2')}
            `}
          >
            {tokenManager}
          </Text>
        }
      />
      <Tabs
        items={['Tab 1', 'Tab 2']}
        selected={pageIndex}
        onChange={index => requestPath(`/tab/${index + 1}`)}
      />
      <Box
        css={`
          display: flex;
          align-items: center;
          justify-content: center;
          text-align: center;
          height: ${50 * GU}px;
          ${textStyle('title3')};
        `}
      >
        Count: {count}
        <TextInput
          value={tm}
          onChange={event => {
            setTM(event.target.value)
          }}
        />  
        <Buttons>
          <Button
            display="icon"
            icon={<IconMinus />}
            label="Add Address"
            onClick={() => api.setTokenManager(tm).toPromise()}
          />
        <TextInput
          value={v}
          onChange={event => {
            setVault(event.target.value)
          }}
        />  
          <Button
            display="icon"
            icon={<IconPlus />}
            label="Set Vault"
            onClick={() => api.setV(1).toPromise()}
            css={`
              margin-left: ${2 * GU}px;
            `}
          />
        </Buttons>
      </Box>
    </Main>
  )
}

const Buttons = styled.div`
  display: grid;
  grid-auto-flow: column;
  grid-gap: 40px;
  margin-top: 20px;
`

export default App
