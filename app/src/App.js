import React from 'react'
import { useViewport } from 'use-viewport'
import { useAragonApi } from '@aragon/api-react'
import {
  Box,
  Card,
  Bar,
  BackButton,
  CircleGraph,
  Distribution,
  TokenInfoBoxRow,
  Split,
  Button,
  ContextMenu,
  ContextMenuItem,
  DataView,
  GU,
  Header,
  IconUnlock,
  IconFundraising,
  IconLock,
  IconTrash,
  IdentityBadge,
  Main,
  SyncIndicator,
  Tag,
  textStyle,
  useTheme,
} from '@aragon/ui'

function App() {
  const { api, appState } = useAragonApi()

  const { count, isSyncing } = appState

  const theme = useTheme()
  const { below } = useViewport()

  const compactMode = below('medium')

  return (
    <Main>
      {isSyncing && <SyncIndicator />}
      <Header
        primary={
          <div
            css={`
              display: flex;
              justify-content: center;
              align-items: center;
            `}
          >
            <div
              css={`
                ${textStyle('title2')}
              `}
            >
              Token Sale
            </div>
            <Tag
              mode="identifier"
              label="TKN"
              css={`
                margin-left: ${1 * GU}px;
                margin-top: ${0.5 * GU}px;
              `}
            />
          </div>
        }
        secondary={
          <>
            <Button
              mode="strong"
              label="Buy Tokens"
              icon={<IconFundraising />}
              display={compactMode ? 'icon' : 'all'}
              onClick={() => api.increment(1).toPromise()}
              css={`
                margin-right: ${1 * GU}px;
              `}
            />
          </>
        }
      />

      <div
        css={`
          width: ${10 * GU}px;
          padding: ${1 * GU}px ${2 * GU}px;
        `}
      />
      <Split
        primary={<DataView
          fields={['Beneficiary', 'ETH', 'TKN']}
          entries={[
            { account: '0xb4124cEB3451635DAcedd11767f004d8a28c6eE7', raised: '50', rate: '50000' },
            { account: '0x8401Eb5ff34cc943f096A32EF3d5113FEbE8D4Eb', raised: '14', rate: '14000' },
            { account: '0x306469457266CBBe7c0505e8Aad358622235e768', raised: '200', rate: '200000'},
            { account: '0xd873F6DC68e3057e4B7da74c6b304d0eF0B484C7', raised: '10', rate: '10000' },
            { account: '0x9766D2e7FFde358AD0A40BB87c4B88D9FAC3F4dd', raised: '15', rate: '15000' },
            { account: '0xBd7055AB500cD1b0b0B14c82BdBe83ADCc2e8D06', raised: '30', rate: '30000' },
            { account: '0xe8898A4E589457D979Da4d1BDc35eC2aaf5a3f8E', raised: '13', rate: '13000' },
            { account: '0x5790dB5E4D9e868BB86F5280926b9838758234DD', raised: '1', rate: '1000'  },
          ]}
          renderEntry={({ account, raised, rate }) => {
            return [
              <IdentityBadge entity={account} />,
              <div
                css={`
                  ${textStyle('body2')}
                  justify-content: center;
                  align-items: center;
                `}
              >
                {raised}
              </div>,
              <div
              css={`
                ${textStyle('body2')}
              `}
            >
              {rate}
            </div>,
            ]
          }}
        />}
        secondary={
          <>
            <Box heading="Token info">
              <div
              css={`
                display: flex;
                justify-content: space-between;
              `}
              >
                <div
                  css={`
                    color: ${theme.surfaceContentSecondary};
                  `}
                >
                  {'Rate:'}
                </div>
                <div><Tag mode="indicator">{'0.001 Ξ'}</Tag></div>
              </div>
              <div
              css={`
                display: flex;
                justify-content: space-between;
              `}
              >
                <div
                  css={`
                    color: ${theme.surfaceContentSecondary};
                  `}
                >
                  {'Hard Cap:'}
                </div>
                <div><Tag mode="indicator">{'1,000,000 TKN'}</Tag></div>

              </div>
              <div
              css={`
                display: flex;
                justify-content: space-between;
              `}
              >
                <div
                  css={`
                    color: ${theme.surfaceContentSecondary};
                  `}
                >
                  {'Tokens Sold:'}
                </div>
                <div><Tag mode="indicator">{'333,000 TKN'}</Tag></div>
              </div>
              <div
              css={`
                display: flex;
                justify-content: space-between;
              `}
              >
                <div
                  css={`
                    color: ${theme.surfaceContentSecondary};
                  `}
                >
                  {'ETH Raised:'}
                </div>
                <div><Tag mode="new">{'333 Ξ'}</Tag></div>
              </div>
            </Box>
            <Box heading="Sale Metrics">
              <CircleGraph value={1/3} size={220} />
            </Box>
      </>
        }
      />
      
    </Main>
  )

  // TokenInfoBoxRow is relying on useTheme() to get a specific text color.
function TokenInfoBoxRow({ primary, secondary }) {
  const theme = useTheme()
  return (
    <div
      css={`
        display: flex;
        justify-content: space-between;
      `}
    >
      <div
        css={`
          color: ${theme.surfaceContentSecondary};
        `}
      >
        {primary}
      </div>
      <div>{secondary}</div>
    </div>
  )
}
}

export default App
