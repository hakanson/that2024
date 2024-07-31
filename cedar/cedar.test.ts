import {
  Context,
  Decision,
  EntityJson,
  PolicySet,
  TypeAndId,
} from '@cedar-policy/cedar-wasm';
import { readFileSync } from 'node:fs';
import { expect, test, beforeAll, suite } from 'vitest';
//import * as cedar from '@cedar-policy/cedar-wasm';
const cedar = require('@cedar-policy/cedar-wasm/nodejs');

suite('Cedar version', async () => {
  test('Cedar version: 3.2.1', () => {
    expect(cedar.getCedarVersion()).toBe('3.2.1');
  });
});

const JANEDOE = { type: 'PhotoApp::User', id: 'JaneDoe' };
const JOHNDOE = { type: 'PhotoApp::User', id: 'JohnDoe' };
const JORGESOUZA = { type: 'PhotoApp::User', id: 'JorgeSouza' };

const VIEWPHOTO = { type: 'PhotoApp::Action', id: 'viewPhoto' };

const JANEDOE_JPG = { type: 'PhotoApp::Photo', id: 'JaneDoe.jpg' };
const JOHNDOE_JPG = { type: 'PhotoApp::Photo', id: 'JohnDoe.jpg' };
const NIGHTCLUB_JPG = { type: 'PhotoApp::Photo', id: 'nightclub.jpg' };
const SUNSET_JPG = { type: 'PhotoApp::Photo', id: 'sunset.jpg' };
const JUDGES_JPG = { type: 'PhotoApp::Photo', id: 'Judges.jpg' };

const policies: PolicySet = readFileSync(
  './testdata/temppolicies.cedar',
  'utf-8'
);
const entitiesJson: string = readFileSync('./cedarentities.json', 'utf-8');
const entities: Array<EntityJson> = JSON.parse(entitiesJson);

function viewPhoto(
  decision: Decision,
  principal: TypeAndId,
  resource: TypeAndId,
  context: Context
) {
  const answer = cedar.isAuthorized({
    principal: principal,
    action: VIEWPHOTO,
    resource: resource,
    context: context,
    slice: {
      policies: policies,
      entities: entities,
    },
  });

  expect(answer.type).toBe('success');
  expect(answer.response.decision).toBe(decision);
}

suite('Album DoePhotos', async () => {
  test('JaneDoe view JohnDoe.jpg', () => {
    viewPhoto('Allow', JANEDOE, JOHNDOE_JPG, {});
  });

  test('JohnDoe view JaneDoe.jpg', () => {
    viewPhoto('Allow', JOHNDOE, JANEDOE_JPG, {});
  });

  test('JorgeSouza view JaneDoe.jpg', () => {
    viewPhoto('Deny', JORGESOUZA, JANEDOE_JPG, {});
  });
});

suite('Album JaneVacation', async () => {
  test('JaneDoe view nightclub.jpg', () => {
    viewPhoto('Allow', JANEDOE, NIGHTCLUB_JPG, {});
  });

  test('JohnDoe view nightclub.jpg', () => {
    viewPhoto('Deny', JOHNDOE, NIGHTCLUB_JPG, {});
  });

  test('JaneDoe view sunset.jpg', () => {
    viewPhoto('Allow', JANEDOE, SUNSET_JPG, {});
  });

  test('JohnDoe view sunset.jpg', () => {
    viewPhoto('Allow', JOHNDOE, SUNSET_JPG, {});
  });
});

suite('Role PhotoJudge', async () => {
  test('JorgeSouza view sunset.jpg session', () => {
    viewPhoto('Allow', JORGESOUZA, SUNSET_JPG, { judgingSession: true });
  });

  test('JorgeSouza view sunset.jpg nosession', () => {
    viewPhoto('Deny', JORGESOUZA, SUNSET_JPG, { judgingSession: false });
  });
});

suite('User JorgeSouza', async () => {
  test('JorgeSouza view sunset.jpg', () => {
    viewPhoto('Allow', JORGESOUZA, JUDGES_JPG, {});
  });

  test('JorgeSouza view nightclub.jpg', () => {
    viewPhoto('Deny', JORGESOUZA, NIGHTCLUB_JPG, {});
  });

  test('JorgeSouza view sunset.jpg', () => {
    viewPhoto('Deny', JORGESOUZA, SUNSET_JPG, {});
  });
});
