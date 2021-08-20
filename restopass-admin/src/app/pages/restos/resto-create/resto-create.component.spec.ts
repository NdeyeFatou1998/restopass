import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RestoCreateComponent } from './resto-create.component';

describe('RestoCreateComponent', () => {
  let component: RestoCreateComponent;
  let fixture: ComponentFixture<RestoCreateComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RestoCreateComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RestoCreateComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
