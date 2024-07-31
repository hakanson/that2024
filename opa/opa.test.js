import { readFileSync } from 'node:fs';
import { expect, test, describe, beforeAll } from 'vitest';
import { loadPolicy } from '@open-policy-agent/opa-wasm';

describe('photoapp test suite', async () => {
  let policy;

  beforeAll(async () => {
    const policyWasm = readFileSync('policy.wasm');
    policy = await loadPolicy(policyWasm);
    const data = readFileSync('data.json');
    policy.setData(JSON.parse(data.toString()));
  });

  function isAuthorized(regoinput, decision, policyId) {
    const input = readFileSync(`input/${regoinput}.regoinput.json`);
    const resultSet = policy.evaluate(JSON.parse(input.toString()));
    expect(resultSet).not.toBeNull();
    expect(resultSet.length).toBe(1);
    expect(resultSet[0].result.decision).toEqual(decision);
    expect(resultSet[0].result.determiningPolicies).toContain(policyId);
  }

  test.each([
    ['JaneDoe-view-JohnDoe', 'ALLOW', 'DoePhotos'],
    ['JorgeSouza-view-sunset', 'ALLOW', 'PhotoJudge'],
  ])('%s', async (regoinput, decision, policy) => {
    isAuthorized(regoinput, decision, policy);
  });
});
