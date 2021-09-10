import { ComponentFixture, TestBed } from '@angular/core/testing';

import { VigilShowComponent } from './vigil-show.component';

describe('VigilShowComponent', () => {
  let component: VigilShowComponent;
  let fixture: ComponentFixture<VigilShowComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ VigilShowComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(VigilShowComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
